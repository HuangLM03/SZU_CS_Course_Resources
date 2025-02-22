#include <bits/stdc++.h>
using namespace std;

int main() {
    cout << "please enter two numbers:" << '\n';
    
    int num1, num2; cin >> num1 >> num2;

    long long ans = 0;
    for (int i = 32; i; num1 >>= 1, num2 <<= 1, i--) 
        if (num1 & 1) ans += num2;
    
    cout << "result:" << '\n';
    cout << ans << '\n';

    ans >>= 32;
    if (ans) cout << "warning: result overflow" << '\n';
    return 0;
}