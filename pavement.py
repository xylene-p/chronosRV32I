#!/usr/bin/env python3
from paver.easy import *
import os
import shutil
import paver.doctools

@task
def run():
	if os.name == 'nt':
		sh('mkdir output')
		sh('iverilog -Iinc -o output/coreTest.out src/*.v test/*.v')
		sh('vvp output/coreTest.out')
		sh('gtkwave core.vcd &')

@task
def clean():
	sh('rm output/*')
	sh('rmdir output')



@task
@needs(['clean', 'run', 'clean'])
def default():
	pass

