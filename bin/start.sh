#!/bin/sh

bin/kwtool eval "Kwtool.ReleaseTasks.migrate()"

bin/kwtool start
