#!/usr/bin/env python3
from paver.easy import *
import os
import shutil
import paver.doctools

@task
def run():
	if os.name == 'nt':
		sh('mkdir output')
		sh('iverilog -Iinc -o output/coreTest.out src/*.v test/core_tb.v')
		sh('vvp output/coreTest.out')
		sh('gtkwave core.vcd &')

@task
def clean():
	sh('rm output/*')
	sh('rmdir output')


@task 
def inst_mem():
	if os.name == 'nt':
		sh('mkdir output')
		sh('iverilog -Iinc -o output/inst_memTest.out src/inst_mem.v test/inst_mem_tb.v')
		sh('vvp output/inst_memTest.out')
		#sh('gtkwave core.vcd &')
@task
def stageIFIDtest():
		sh('mkdir output')
		sh('iverilog -Iinc -o output/stage_IFID_tb.out src/*.v test/stage_IFID_tb.v')
		sh('vvp output/stage_IFID_tb.out')


@task
@needs(['clean', 'stageIFIDtest', 'clean'])
def default():
	pass

