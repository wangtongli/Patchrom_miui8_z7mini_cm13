import common
import edify_generator
import os
import re
import time
import copy

def RemoveDeviceAssert(info):
  edify = info.script
  for i in xrange(len(edify.script)):
    if "ro.product" in edify.script[i]:
          edify.script[i] = '''ui_print("****************************");
ui_print("*        nubia z7mini     *");
ui_print("*           MIUI  V8       *");
ui_print("*           ''' + time.strftime('%Y-%m',time.localtime(time.time())) + '''        *");
ui_print("****************************");'''
  return
	

def RemoveLinks(info):
  edify = info.script
  for i in xrange(len(edify.script)):
    if "set_perm" in edify.script[i]:
      edify.script[i] = ''
  return


def AddArgsForFormatSystem(info):
  edify = info.script
  for i in xrange(len(edify.script)):
    if "format(" in edify.script[i] and "/dev/block/platform/msm_sdcc.1/by-name/system" in edify.script[i]:
      edify.script[i] = 'format("ext4", "EMMC", "/dev/block/platform/msm_sdcc.1/by-name/system", "0", "/system");'
      return

def WritePolicyConfig(info):
  try:
    file_contexts = info.input_zip.read("META/file_contexts")
    common.ZipWriteStr(info.output_zip, "file_contexts", file_contexts)
  except KeyError:
    print "warning: file_context missing from target;"

def FullOTA_InstallEnd(info):
    RemoveDeviceAssert(info)
    RemoveLinks(info)
    WritePolicyConfig(info)

def IncrementalOTA_InstallEnd(info):
    RemoveDeviceAssert(info)
    RemoveLinks(info)
