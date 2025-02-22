#pragma once

#include <winsock2.h>
#include <stdio.h>

#define KILOBYTE 1024
#define LOG_LENGTH 1000

typedef struct artificial_delay
{
    int base;
    int fluctuate;
    int round;
    struct artificial_delay *next;
} make_delay, *Delay;

Delay delaySequence = NULL, currentDelay = NULL;

int total_log_len = 0;
long period = 0;

void init_fl();
void release_fl();

void Usleep(long microseconds)
{
    LARGE_INTEGER frequency;
    LARGE_INTEGER start;
    LARGE_INTEGER current;

    QueryPerformanceFrequency(&frequency);
    QueryPerformanceCounter(&start);

    long ticksToWait = (frequency.QuadPart * microseconds) / 1000000;

    do
    {
        QueryPerformanceCounter(&current);
    } while ((current.QuadPart - start.QuadPart) < ticksToWait);
}

void load_fl()
{
    Delay temp = NULL;
    int baseDelay, fluctuateDelay, delayRound;
    FILE *file = fopen("variation.cfg", "r");
    while (fscanf(file, "%d,%d,%d", &baseDelay, &fluctuateDelay, &delayRound) != EOF)
    {
        Delay delayStep = malloc(sizeof(make_delay));
        delayStep->base = baseDelay;
        delayStep->fluctuate = fluctuateDelay;
        delayStep->round = delayRound;
        delayStep->next = NULL;
        if (delaySequence == NULL)
        {
            delaySequence = delayStep;
        }
        else
        {
            temp->next = delayStep;
        }
        temp = delayStep;
    }
    currentDelay = delaySequence;
}
int send_fl(SOCKET s, const char *buf, int len, int flags)
{
    int packet_count = 0, send_amount = 0;
    while (len >= 0)
    {
        total_log_len++;
        int s_time = rand() % currentDelay->fluctuate;
        Usleep(currentDelay->base + s_time);
        int send_size = len >= KILOBYTE ? KILOBYTE : len;
        int send_result = send(s, buf + KILOBYTE * packet_count, send_size, flags);
        len -= KILOBYTE;
        packet_count += 1;
        if (send_result < 0)
            return send_result;
        send_amount += send_result;

        currentDelay->round--;
        if (currentDelay->round <= 0)
            currentDelay = currentDelay->next;
        if (currentDelay == NULL)
        {
            release_fl();
            load_fl();
            currentDelay = delaySequence;
        }
    }

    if (total_log_len >= LOG_LENGTH)
    {
        period = GetTickCount() - period;
        printf("Recent %dkB, Rate: %fkB/s\n", total_log_len, LOG_LENGTH * 1024.0 / period);
        period = GetTickCount();
        total_log_len = 0;
        Delay temp = delaySequence;
    }
    return send_amount;
}

void init_fl()
{
    UINT32 Seed = 897932;
    srand(Seed);
    load_fl();
}

void release_fl()
{
    Delay temp = delaySequence;
    Delay next;
    while (temp != NULL)
    {
        next = temp->next;
        free(temp);
        temp = next;
    }
    delaySequence = NULL;
}