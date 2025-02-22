from __future__ import division
import math
from pylab import mpl
# 设置显示中文字体
mpl.rcParams["font.sans-serif"] = ["SimHei"]
# 设置正常显示符号
mpl.rcParams["axes.unicode_minus"] = False
import matplotlib  # noqa
matplotlib.use('Agg')  # noqa
import time
import numpy as np
import matplotlib.pyplot as plt


class Bandit(object):
    def generate_reward(self, i):
        raise NotImplementedError


class BernoulliBandit(Bandit):

    def __init__(self, n, probas=None):
        assert probas is None or len(probas) == n
        self.n = n
        if probas is None:
            np.random.seed(int(time.time()))
            self.probas = [np.random.random() for _ in range(self.n)]
        else:
            self.probas = probas

        self.best_proba = max(self.probas)

    def generate_reward(self, i):
        # The player selected the i-th machine.
        if np.random.random() < self.probas[i]:
            return 1
        else:
            return 0


class BaseSolution:
    def __init__(self, bandit):
        assert isinstance(bandit, BernoulliBandit)
        np.random.seed(int(time.time()))
        self.bandit = bandit
        self.counts = [0] * self.bandit.n
        self.actions = []
        self.regret = 0.0
        self.regrets = [0.0, ]

    def update_regret(self, index):
        self.regret = self.bandit.best_proba - self.bandit.probas[index]
        self.regrets.append(self.regret)

    def start(self, step):
        for i in range(step):
            self.run()

    @property
    def estimated_probas(self):
        raise NotImplementedError

    def run(self):
        raise NotImplementedError


class UCB(BaseSolution):
    def __init__(self, bandit, init_proba=1.0):
        super(UCB, self).__init__(bandit)
        self.count = 0
        self.estimates = [init_proba] * self.bandit.n
        self.sum_reward = 0.0
        self.sum_rewards = [0.0, ]

    def estimated_probas(self):
        return self.estimates

    def run(self):
        ucb_list = [self.estimates[j] + math.sqrt(math.log2(self.count + 1) / 2.0 / (self.counts[j] + 1))
                    for j in range(self.bandit.n)]
        index = ucb_list.index(max(ucb_list))

        reward = self.bandit.generate_reward(index)
        self.estimates[index] = (self.estimates[index] * self.counts[index] + reward) \
                                / (1.0 * self.counts[index] + 1)
        self.counts[index] += 1
        self.count += 1
        self.actions.append(index)
        self.update_regret(index)
        self.update_reward(reward)

    def update_reward(self, reward):
        self.sum_reward += reward
        self.sum_rewards.append(self.sum_reward)


class EpsGreedy(BaseSolution):
    def __init__(self, bandit, eps, init_proba=1.0):
        super(EpsGreedy, self).__init__(bandit)
        self.eps = eps
        self.estimates = [init_proba] * self.bandit.n
        self.sum_reward = 0.0
        self.sum_rewards = [0.0, ]

    @property
    def estimated_probas(self):
        return self.estimates

    def run(self):
        if np.random.random() < self.eps:
            index = np.random.randint(0, self.bandit.n)
        else:
            index = max(range(self.bandit.n), key=lambda x: self.estimates[x])

        reward = self.bandit.generate_reward(index)
        self.estimates[index] = (self.estimates[index] * self.counts[index] + reward) \
                                / (1.0 * self.counts[index] + 1)
        self.counts[index] += 1
        self.actions.append(index)
        self.update_regret(index)
        self.update_reward(reward)

    def update_reward(self, reward):
        self.sum_reward += reward
        self.sum_rewards.append(self.sum_reward)


class Greedy(BaseSolution):
    def __init__(self, bandit, init_proba=1.0):
        super(Greedy, self).__init__(bandit)
        self.estimates = [init_proba] * self.bandit.n
        self.sum_reward = 0.0
        self.sum_rewards = [0.0, ]

    @property
    def estimated_probas(self):
        return self.estimates

    def run(self):
        index = max(range(self.bandit.n), key=lambda x: self.estimates[x])
        reward = self.bandit.generate_reward(index)
        self.estimates[index] = (self.estimates[index] * self.counts[index] + reward) \
                                / (1.0 * self.counts[index] + 1)
        self.counts[index] += 1
        self.actions.append(index)
        self.update_regret(index)
        self.update_reward(reward)

    def update_reward(self, reward):
        self.sum_reward += reward
        self.sum_rewards.append(self.sum_reward)


def show_results_with_different_methods(methods, method_names, figname):
    graph = plt.figure(figsize=(15, 15))
    graph.suptitle('K={} N={}'.format(K, N))
    ax1 = graph.add_subplot(211)
    ax2 = graph.add_subplot(212)

    # 累计收益
    for index, method in enumerate(methods):
        ax1.plot(range(len(method.sum_rewards)), method.sum_rewards,
                 label=method_names[index], alpha=0.7)

    ax1.set_xlabel('步数')
    ax1.set_xticks(range(0, 1001, 100))
    ax1.set_ylabel('累计收益')
    ax1.legend(loc='best')
    # 单次懊悔
    for index, method in enumerate(methods):
        ax2.scatter(range(0, len(method.regrets), 20), method.regrets[0:len(method.regrets):20],
                    label=method_names[index], s=(300 - index * 100))

    ax2.set_xlabel('步数')
    ax2.set_xticks(range(0, 1001, 20))
    ax2.set_ylabel('单次懊悔')
    ax2.legend(loc='best')

    graph.savefig(figname)


def show_results_with_different_arguements(methods, figname):
    graph = plt.figure(figsize=(10, 5))
    graph.suptitle('K={} N={}'.format(K, N))
    ax1 = graph.add_subplot(111)

    # 不同参数的最后收益
    ax1.plot([_.eps for _ in methods], [_.sum_reward for _ in methods])
    ax1.set_xlabel('参数')
    ax1.set_xticks([_ / 100.0 for _ in range(0, 101, 5)])
    ax1.set_ylabel('总收益')

    graph.savefig(figname)
    best_eps, best_reward = 0.01, 0
    for _ in methods:
        if _.sum_reward > best_reward:
            best_eps = _.eps
            best_reward = _.sum_reward
    return best_eps, best_reward


if __name__ == '__main__':
    K, N = 5, 1000
    b = BernoulliBandit(K)
    print("Randomly generated Bernoulli bandit has reward probabilities:\n", b.probas)
    print("The best machine has index: {} and proba: {:.4f}".format(
        max(range(K), key=lambda i: b.probas[i]), max(b.probas)))

    methods = []
    i = 0.01
    while i <= 1:
        methods.append(EpsGreedy(b, i))
        i += 0.01
    for method in methods:
        method.start(N)
    best_arguement, best_reward = show_results_with_different_arguements(methods, "EGreedy不同参数_K{}_N{}.png".format(K, N))
    print("The best arguement is {:.2f}\nThe best reward is {:.2f}".format(best_arguement, best_reward))

    methods = [
        Greedy(b),
        EpsGreedy(b, best_arguement),
        UCB(b),
    ]
    names = [
        'Greedy',
        'EpsilonGreedy(agr={:.2f})'.format(best_arguement),
        'UCB',
    ]
    for method in methods:
        method.start(N)
    show_results_with_different_methods(methods, names, "不同方法_K{}_N{}.png".format(K, N))

