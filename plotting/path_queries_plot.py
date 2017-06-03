#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import csv
import numpy as np
import matplotlib.pyplot as plt

anafile =  open('ana_time.csv', 'r')
ana = csv.reader(anafile)

# Read in time data grouped, and separated by query
by_node_t = dict()
by_query_t = dict()

for row in ana:
    if by_node_t.get(int(row[0])):
        by_node_t[int(row[0])] += [float(row[4])]
    else:
        by_node_t[int(row[0])] = [float(row[4])]
        
    if by_query_t.get(row[2]):
        by_query_t[row[2]] += [(int(row[0]), float(row[4]))]
    else:
        by_query_t[row[2]] = [(int(row[0]), float(row[4]))]

anafile.close()

# Read in count data grouped, and separated by query
anafile =  open('ana_count.csv', 'r')
ana = csv.reader(anafile)

by_node_c = dict()
by_query_c = dict()

for row in ana:
    if by_node_c.get(int(row[0])):
        by_node_c[int(row[0])] += [float(row[4])]
    else:
        by_node_c[int(row[0])] = [float(row[4])]
        
    if by_query_c.get(row[2]):
        by_query_c[row[2]] += [(int(row[0]), float(row[4]))]
    else:
        by_query_c[row[2]] = [(int(row[0]), float(row[4]))]

anafile.close()

# Output plots by query
def plotRes(dat, title, is_by_query):
    by_node = []
    if is_by_query:
        by_node = dict()
        for row in dat:
            if by_node.get(row[0]):
                by_node[row[0]] += [row[1]]
            else:
                by_node[row[0]] = [row[1]]
    else:
        by_node = dat
    n = []
    n_avg = []
    n_std = []
    n_bx = []

    for key in by_node:
        n += [key]
        n_avg += [np.mean(by_node[key])]
        n_std +=[np.std(by_node[key])]
        n_bx += [by_node[key]]
    
    plt.figure()
    plt.boxplot(n_bx, labels=n)
    plt.grid()
    plt.title(title)
    plt.savefig(title + '.png')
    
    plt.figure()
    plt.plot(n, n_avg, 'rs-', fillstyle='none')
    plt.title(title)
    plt.grid()
    plt.savefig(title + '_boxplot.png')
    

  
for key in by_query_t:
    plotRes(by_query_t[key], key + '_t', True)

for key in by_query_c:
    plotRes(by_query_c[key], key + '_c', True)
    
    
# Output plots for bundled queries
def plotAllQueries(dat_t, dat_c):

    n = []
    t_avg = []
    t_std = []
    t_bx = []

    for key in dat_t:
        n += [key]
        t_avg += [np.mean(dat_t[key])]
        t_std +=[np.std(dat_t[key])]
        t_bx += [dat_t[key]]
    c_avg = []
    c_std = []
    c_bx = []

    for key in dat_c:
        c_avg += [np.mean(dat_c[key])]
        c_std +=[np.std(dat_c[key])]
        c_bx += [dat_c[key]]

    plt.figure()
    plt.boxplot(c_bx, labels=n)
    plt.grid()
    plt.title('Rule Counts')

    plt.savefig('all_queries_c.png')

    plt.figure()
    plt.boxplot(t_bx, labels=n)
    plt.grid()
    plt.title('Compile Times (s)')

    plt.savefig('all_queries_t.png')

    # two axes in one plot adapted from stackoverflow
    fig, ax1 = plt.subplots()
    ax2 = ax1.twinx()
    l2, = ax1.plot(n, c_avg, 'ko-', label='#Rules')
    ax1.set_ylim((0,900))
    l1, = ax2.plot(n, t_avg, 'rs-', fillstyle='none', label='Compile time (s)')
    ax2.set_ylim((0,50))
    ax1.set_xlabel('Number of nodes')
    ax1.set_ylabel('#Ingress Rules')
    ax2.set_ylabel('Compile time (s)')
    plt.legend((l1, l2), (l1.get_label(), l2.get_label()))
    
    plt.grid()
    plt.savefig('all_queries.png')    
    


plotAllQueries(by_node_t, by_node_c)