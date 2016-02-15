#BlueScreen
-----
#Killer网卡驱动导致蓝屏
收到的 b85 gaming 组好后 killer网卡用几个小时就蓝屏，  e22w7x64.sys 这个报错，你们这有 killer 网卡驱动吗？

http://support.icafe8.com/technologynews/focus/932.html
1、运行WinDbg软件，然后按【Ctrl+S】弹出符号表设置窗
2、将符号表地址：SRV*C:\Symbols*http://msdl.microsoft.com/download/symbols粘贴在输入框中，点击确定即可。
注：红色字体为符号表本地存储路径，建议固定路径，可避免符号表重复下载。

　当你拿到一个dmp文件后，可使用【Ctrl+D】快捷键来打开一个dmp文件，或者点击WinDbg界面上的【File=>Open Crash Dump...】按钮，来打开一个dmp文件。第一次打开dmp文件时，可能会收到如下提示，出现这个提示时，勾选“Don't ask again in this WinDbg session”，然后点否即可。

　　当你想打开第二个dmp文件时，可能因为上一个分析记录未清除，导致无法直接分析下一个dmp文件，此时你可以使用快捷键【Shift+F5】来关闭上一个dmp分析记录。

5-12
Microsoft (R) Windows Debugger Version 6.12.0002.633 X86
Copyright (c) Microsoft Corporation. All rights reserved.

Loading Dump File [C:\Windows\Minidump\051215-9952-01.dmp]
Mini Kernel Dump File: Only registers and stack trace are available

WARNING: Whitespace at end of path element
Symbol search path is: SRV*DownstreamStore*http://msdl.microsoft.com/download/symbols　
Executable search path is: 
Windows 7 Kernel Version 7601 (Service Pack 1) MP (4 procs) Free x64
Product: WinNt, suite: TerminalServer SingleUserTS
Built by: 7601.18798.amd64fre.win7sp1_gdr.150316-1654
Machine Name:
Kernel base = 0xfffff800`04401000 PsLoadedModuleList = 0xfffff800`04646890
Debug session time: Tue May 12 21:07:26.493 2015 (UTC + 8:00)
System Uptime: 0 days 1:28:02.450
Loading Kernel Symbols
...............................................................
................................................................
.....................................................
Loading User Symbols
Loading unloaded module list
......
*******************************************************************************
*                                                                             *
*                        Bugcheck Analysis                                    *
*                                                                             *
*******************************************************************************

Use !analyze -v to get detailed debugging information.

BugCheck 1E, {0, 0, 0, 0}

Unable to load image nvlddmkm.sys, Win32 error 0n2
*** WARNING: Unable to verify timestamp for nvlddmkm.sys
*** ERROR: Module load completed but symbols could not be loaded for nvlddmkm.sys
Probably caused by : nvlddmkm.sys ( nvlddmkm+41544d )

Followup: MachineOwner
---------

0: kd> !analyze -v
*******************************************************************************
*                                                                             *
*                        Bugcheck Analysis                                    *
*                                                                             *
*******************************************************************************

KMODE_EXCEPTION_NOT_HANDLED (1e)
This is a very common bugcheck.  Usually the exception address pinpoints
the driver/function that caused the problem.  Always note this address
as well as the link date of the driver/image that contains this address.
Arguments:
Arg1: 0000000000000000, The exception code that was not handled
Arg2: 0000000000000000, The address that the exception occurred at
Arg3: 0000000000000000, Parameter 0 of the exception
Arg4: 0000000000000000, Parameter 1 of the exception

Debugging Details:
------------------


EXCEPTION_CODE: (NTSTATUS) 0 (0) - STATUS_WAIT_0

FAULTING_IP: 
+56ea2faf0428debc
00000000`00000000 ??              ???

EXCEPTION_PARAMETER1:  0000000000000000

EXCEPTION_PARAMETER2:  0000000000000000

ERROR_CODE: (NTSTATUS) 0 - STATUS_WAIT_0

BUGCHECK_STR:  0x1E_0

CUSTOMER_CRASH_COUNT:  1

DEFAULT_BUCKET_ID:  VISTA_DRIVER_FAULT

PROCESS_NAME:  GTA5.exe

CURRENT_IRQL:  2

EXCEPTION_RECORD:  fffff80000ba27c8 -- (.exr 0xfffff80000ba27c8)
ExceptionAddress: fffff880078f344d (nvlddmkm+0x000000000041544d)
   ExceptionCode: c0000005 (Access violation)
  ExceptionFlags: 00000000
NumberParameters: 2
   Parameter[0]: 0000000000000000
   Parameter[1]: ffffffffffffffff
Attempt to read from address ffffffffffffffff

TRAP_FRAME:  fffff80000ba2870 -- (.trap 0xfffff80000ba2870)
NOTE: The trap frame does not contain all registers.
Some register values may be zeroed or incorrect.
rax=0000000000000057 rbx=0000000000000000 rcx=ccccccc338c48348
rdx=000000000d8fe420 rsi=0000000000000000 rdi=0000000000000000
rip=fffff880078f344d rsp=fffff80000ba2a00 rbp=fffffa8007833010
 r8=fffff80000ba29d0  r9=0000000000001400 r10=0000000000000000
r11=fffff80000ba2980 r12=0000000000000000 r13=0000000000000000
r14=0000000000000000 r15=0000000000000000
iopl=0         nv up ei pl zr na po nc
nvlddmkm+0x41544d:
fffff880`078f344d ??              ???
Resetting default scope

LAST_CONTROL_TRANSFER:  from fffff8000446b43e to fffff80004473a10

STACK_TEXT:  
fffff800`00ba18a8 fffff800`0446b43e : 00007fff`0764ffff ffffff1e`00000000 fffff800`00ba2020 fffff800`0449f650 : nt!KeBugCheck
fffff800`00ba18b0 fffff800`0449f31d : fffff800`04687290 fffff800`045bf6c0 fffff800`04401000 fffff800`00ba27c8 : nt!KiKernelCalloutExceptionHandler+0xe
fffff800`00ba18e0 fffff800`0449e0f5 : fffff800`045c7b74 fffff800`00ba1958 fffff800`00ba27c8 fffff800`04401000 : nt!RtlpExecuteHandlerForException+0xd
fffff800`00ba1910 fffff800`044af081 : fffff800`00ba27c8 fffff800`00ba2020 fffff800`00000000 fffff880`00000005 : nt!RtlDispatchException+0x415
fffff800`00ba1ff0 fffff800`044730c2 : fffff800`00ba27c8 00000000`00000000 fffff800`00ba2870 00000000`00000000 : nt!KiDispatchException+0x135
fffff800`00ba2690 fffff800`044719ca : fffffa80`0719ed80 fffffa80`0c3c5000 fffffa80`0719ed80 fffff880`0767da9f : nt!KiExceptionDispatch+0xc2
fffff800`00ba2870 fffff880`078f344d : 00000000`00200080 00000000`00000001 fffff880`078f2e19 00000000`00000000 : nt!KiGeneralProtectionFault+0x10a
fffff800`00ba2a00 00000000`00200080 : 00000000`00000001 fffff880`078f2e19 00000000`00000000 00000000`0d8fe420 : nvlddmkm+0x41544d
fffff800`00ba2a08 00000000`00000001 : fffff880`078f2e19 00000000`00000000 00000000`0d8fe420 fffff880`fffffa80 : 0x200080
fffff800`00ba2a10 fffff880`078f2e19 : 00000000`00000000 00000000`0d8fe420 fffff880`fffffa80 fffffa80`066bd000 : 0x1
fffff800`00ba2a18 00000000`00000000 : 00000000`0d8fe420 fffff880`fffffa80 fffffa80`066bd000 fffffa80`0d8fe420 : nvlddmkm+0x414e19


STACK_COMMAND:  kb

FOLLOWUP_IP: 
nvlddmkm+41544d
fffff880`078f344d ??              ???

SYMBOL_STACK_INDEX:  7

SYMBOL_NAME:  nvlddmkm+41544d

FOLLOWUP_NAME:  MachineOwner

MODULE_NAME: nvlddmkm

IMAGE_NAME:  nvlddmkm.sys

DEBUG_FLR_IMAGE_TIMESTAMP:  550304cc

FAILURE_BUCKET_ID:  X64_0x1E_0_nvlddmkm+41544d

BUCKET_ID:  X64_0x1E_0_nvlddmkm+41544d

Followup: MachineOwner
---------



5-11

Microsoft (R) Windows Debugger Version 6.12.0002.633 X86
Copyright (c) Microsoft Corporation. All rights reserved.


Loading Dump File [C:\Windows\Minidump\051115-9890-01.dmp]
Mini Kernel Dump File: Only registers and stack trace are available

WARNING: Whitespace at end of path element
Symbol search path is: SRV*DownstreamStore*http://msdl.microsoft.com/download/symbols　
Executable search path is: 
Windows 7 Kernel Version 7601 (Service Pack 1) MP (4 procs) Free x64
Product: WinNt, suite: TerminalServer SingleUserTS
Built by: 7601.18798.amd64fre.win7sp1_gdr.150316-1654
Machine Name:
Kernel base = 0xfffff800`0441b000 PsLoadedModuleList = 0xfffff800`04660890
Debug session time: Mon May 11 23:36:50.225 2015 (UTC + 8:00)
System Uptime: 0 days 0:24:46.181
Loading Kernel Symbols
...............................................................
................................................................
.....................................................
Loading User Symbols
Loading unloaded module list
......
*******************************************************************************
*                                                                             *
*                        Bugcheck Analysis                                    *
*                                                                             *
*******************************************************************************

Use !analyze -v to get detailed debugging information.

BugCheck 116, {fffffa80118514e0, fffff88007c4c2dc, ffffffffc000009a, 4}

*** WARNING: Unable to verify timestamp for nvlddmkm.sys
*** ERROR: Module load completed but symbols could not be loaded for nvlddmkm.sys
Probably caused by : nvlddmkm.sys ( nvlddmkm+79c2dc )

Followup: MachineOwner
---------

2: kd> !analyze -v
*******************************************************************************
*                                                                             *
*                        Bugcheck Analysis                                    *
*                                                                             *
*******************************************************************************

VIDEO_TDR_FAILURE (116)
Attempt to reset the display driver and recover from timeout failed.
Arguments:
Arg1: fffffa80118514e0, Optional pointer to internal TDR recovery context (TDR_RECOVERY_CONTEXT).
Arg2: fffff88007c4c2dc, The pointer into responsible device driver module (e.g. owner tag).
Arg3: ffffffffc000009a, Optional error code (NTSTATUS) of the last failed operation.
Arg4: 0000000000000004, Optional internal context dependent data.

Debugging Details:
------------------


FAULTING_IP: 
nvlddmkm+79c2dc
fffff880`07c4c2dc 48ff257d97edff  jmp     qword ptr [nvlddmkm+0x675a60 (fffff880`07b25a60)]

DEFAULT_BUCKET_ID:  GRAPHICS_DRIVER_TDR_FAULT

CUSTOMER_CRASH_COUNT:  1

BUGCHECK_STR:  0x116

PROCESS_NAME:  System

CURRENT_IRQL:  0

STACK_TEXT:  
fffff880`04b18a48 fffff880`07f18134 : 00000000`00000116 fffffa80`118514e0 fffff880`07c4c2dc ffffffff`c000009a : nt!KeBugCheckEx
fffff880`04b18a50 fffff880`07eeb867 : fffff880`07c4c2dc fffffa80`0dbb8000 00000000`00000000 ffffffff`c000009a : dxgkrnl!TdrBugcheckOnTimeout+0xec
fffff880`04b18a90 fffff880`07f17f43 : fffffa80`ffffd846 00000000`00000000 fffffa80`118514e0 00000000`00000000 : dxgkrnl!DXGADAPTER::Reset+0x2a3
fffff880`04b18b40 fffff880`07fe803d : fffffa80`0f504010 00000000`00000080 00000000`00000000 fffffa80`0db91010 : dxgkrnl!TdrResetFromTimeout+0x23
fffff880`04b18bc0 fffff800`04727aba : 00000000`0254c20a fffffa80`0db948b0 fffffa80`066b4040 fffffa80`0db948b0 : dxgmms1!VidSchiWorkerThread+0x101
fffff880`04b18c00 fffff800`0447f426 : fffff800`0460de80 fffffa80`0db948b0 fffff800`0461bcc0 00000000`ffffffff : nt!PspSystemThreadStartup+0x5a
fffff880`04b18c40 00000000`00000000 : fffff880`04b19000 fffff880`04b13000 fffff880`04b17340 00000000`00000000 : nt!KxStartSystemThread+0x16


STACK_COMMAND:  .bugcheck ; kb

FOLLOWUP_IP: 
nvlddmkm+79c2dc
fffff880`07c4c2dc 48ff257d97edff  jmp     qword ptr [nvlddmkm+0x675a60 (fffff880`07b25a60)]

SYMBOL_NAME:  nvlddmkm+79c2dc

FOLLOWUP_NAME:  MachineOwner

MODULE_NAME: nvlddmkm

IMAGE_NAME:  nvlddmkm.sys

DEBUG_FLR_IMAGE_TIMESTAMP:  550304cc

FAILURE_BUCKET_ID:  X64_0x116_IMAGE_nvlddmkm.sys

BUCKET_ID:  X64_0x116_IMAGE_nvlddmkm.sys

Followup: MachineOwner
---------


05-10
问题签名:
  问题事件名称: BlueScreen
  OS 版本: 6.1.7601.2.1.0.256.1
  区域设置 ID: 2052

有关该问题的其他信息:
  BCCode: 116
  BCP1: FFFFFA801D359010
  BCP2: FFFFF88007BE2A08
  BCP3: FFFFFFFFC000009A
  BCP4: 0000000000000004
  OS Version: 6_1_7601
  Service Pack: 1_0
  Product: 256_1

有助于描述该问题的文件:
  C:\Windows\Minidump\051015-11949-01.dmp
  C:\Windows\Temp\WER-20389-0.sysdata.xml

联机阅读隐私声明:
  http://go.microsoft.com/fwlink/?linkid=104288&clcid=0x0804

如果无法获取联机隐私声明，请脱机阅读我们的隐私声明:
  C:\Windows\system32\zh-CN\erofflps.txt


Microsoft (R) Windows Debugger Version 6.12.0002.633 X86
Copyright (c) Microsoft Corporation. All rights reserved.


Loading Dump File [C:\Windows\Minidump\051015-11949-01.dmp]
Mini Kernel Dump File: Only registers and stack trace are available

WARNING: Whitespace at end of path element
Symbol search path is: SRV*DownstreamStore*http://msdl.microsoft.com/download/symbols　
Executable search path is: 
Windows 7 Kernel Version 7601 (Service Pack 1) MP (4 procs) Free x64
Product: WinNt, suite: TerminalServer SingleUserTS
Built by: 7601.18798.amd64fre.win7sp1_gdr.150316-1654
Machine Name:
Kernel base = 0xfffff800`0445d000 PsLoadedModuleList = 0xfffff800`046a2890
Debug session time: Sun May 10 23:21:16.893 2015 (UTC + 8:00)
System Uptime: 0 days 12:53:32.876
Loading Kernel Symbols
.
Followup: MachineOwner
---------
BugCheck 116, {fffffa801d359010, fffff88007be2a08, ffffffffc000009a, 4}

*** WARNING: Unable to verify timestamp for nvlddmkm.sys
*** ERROR: Module load completed but symbols could not be loaded for nvlddmkm.sys
Probably caused by : nvlddmkm.sys ( nvlddmkm+7aca08 )


3: kd> !analyze -v
*******************************************************************************
*                                                                             *
*                        Bugcheck Analysis                                    *
*                                                                             *
*******************************************************************************

VIDEO_TDR_FAILURE (116)
Attempt to reset the display driver and recover from timeout failed.
Arguments:
Arg1: fffffa801d359010, Optional pointer to internal TDR recovery context (TDR_RECOVERY_CONTEXT).
Arg2: fffff88007be2a08, The pointer into responsible device driver module (e.g. owner tag).
Arg3: ffffffffc000009a, Optional error code (NTSTATUS) of the last failed operation.
Arg4: 0000000000000004, Optional internal context dependent data.

Debugging Details:
------------------


FAULTING_IP: 
nvlddmkm+7aca08
fffff880`07be2a08 48ff258126edff  jmp     qword ptr [nvlddmkm+0x67f090 (fffff880`07ab5090)]

DEFAULT_BUCKET_ID:  GRAPHICS_DRIVER_TDR_FAULT

CUSTOMER_CRASH_COUNT:  1

BUGCHECK_STR:  0x116

PROCESS_NAME:  System

CURRENT_IRQL:  0

STACK_TEXT:  
fffff880`0594aa48 fffff880`07ecb134 : 00000000`00000116 fffffa80`1d359010 fffff880`07be2a08 ffffffff`c000009a : nt!KeBugCheckEx
fffff880`0594aa50 fffff880`07e9e867 : fffff880`07be2a08 fffffa80`0dae0000 00000000`00000000 ffffffff`c000009a : dxgkrnl!TdrBugcheckOnTimeout+0xec
fffff880`0594aa90 fffff880`07ecaf43 : fffffa80`ffffd846 ffffffff`fffe7960 fffffa80`1d359010 00000000`00000000 : dxgkrnl!DXGADAPTER::Reset+0x2a3
fffff880`0594ab40 fffff880`07f9b03d : fffffa80`11155070 00000000`00000080 00000000`00000000 fffffa80`0dadf410 : dxgkrnl!TdrResetFromTimeout+0x23
fffff880`0594abc0 fffff800`04769aba : 00000000`01d4043c fffffa80`0d5a88b0 fffffa80`06646840 fffffa80`0d5a88b0 : dxgmms1!VidSchiWorkerThread+0x101
fffff880`0594ac00 fffff800`044c1426 : fffff800`0464fe80 fffffa80`0d5a88b0 fffff800`0465dcc0 00000000`00000000 : nt!PspSystemThreadStartup+0x5a
fffff880`0594ac40 00000000`00000000 : fffff880`0594b000 fffff880`05945000 fffff880`05949340 00000000`00000000 : nt!KxStartSystemThread+0x16


STACK_COMMAND:  .bugcheck ; kb

FOLLOWUP_IP: 
nvlddmkm+7aca08
fffff880`07be2a08 48ff258126edff  jmp     qword ptr [nvlddmkm+0x67f090 (fffff880`07ab5090)]

SYMBOL_NAME:  nvlddmkm+7aca08

FOLLOWUP_NAME:  MachineOwner

MODULE_NAME: nvlddmkm

IMAGE_NAME:  nvlddmkm.sys

DEBUG_FLR_IMAGE_TIMESTAMP:  55259065

FAILURE_BUCKET_ID:  X64_0x116_IMAGE_nvlddmkm.sys

BUCKET_ID:  X64_0x116_IMAGE_nvlddmkm.sys

Followup: MachineOwner
---------




05-04


Microsoft (R) Windows Debugger Version 6.12.0002.633 X86
Copyright (c) Microsoft Corporation. All rights reserved.


Loading Dump File [C:\Windows\Minidump\040315-13665-01.dmp]
Mini Kernel Dump File: Only registers and stack trace are available

WARNING: Whitespace at end of path element
Symbol search path is: SRV*DownstreamStore*http://msdl.microsoft.com/download/symbols　
Executable search path is: 
Windows 7 Kernel Version 7601 (Service Pack 1) MP (4 procs) Free x64
Product: WinNt, suite: TerminalServer SingleUserTS
Built by: 7601.18798.amd64fre.win7sp1_gdr.150316-1654
Machine Name:
Kernel base = 0xfffff800`04265000 PsLoadedModuleList = 0xfffff800`044aa890
Debug session time: Fri Apr  3 00:35:21.624 2015 (UTC + 8:00)
System Uptime: 0 days 4:38:22.576
Loading Kernel Symbols
.

Press ctrl-c (cdb, kd, ntsd) or ctrl-break (windbg) to abort symbol loads that take too long.
Run !sym noisy before .reload to track down problems loading symbols.

..............................................................
................................................................
..........................................
Loading User Symbols
Loading unloaded module list
.....
*******************************************************************************
*                                                                             *
*                        Bugcheck Analysis                                    *
*                                                                             *
*******************************************************************************

Use !analyze -v to get detailed debugging information.

BugCheck D1, {0, 2, 0, fffff88006dd6c8f}

Unable to load image e22w7x64.sys, Win32 error 0n2
*** WARNING: Unable to verify timestamp for e22w7x64.sys
*** ERROR: Module load completed but symbols could not be loaded for e22w7x64.sys
Probably caused by : e22w7x64.sys ( e22w7x64+6c8f )

Followup: MachineOwner
---------


0: kd> !analyze -v
*******************************************************************************
*                                                                             *
*                        Bugcheck Analysis                                    *
*                                                                             *
*******************************************************************************

DRIVER_IRQL_NOT_LESS_OR_EQUAL (d1)
An attempt was made to access a pageable (or completely invalid) address at an
interrupt request level (IRQL) that is too high.  This is usually
caused by drivers using improper addresses.
If kernel debugger is available get stack backtrace.
Arguments:
Arg1: 0000000000000000, memory referenced
Arg2: 0000000000000002, IRQL
Arg3: 0000000000000000, value 0 = read operation, 1 = write operation
Arg4: fffff88006dd6c8f, address which referenced memory

Debugging Details:
------------------


READ_ADDRESS: GetPointerFromAddress: unable to read from fffff80004514100
 0000000000000000 

CURRENT_IRQL:  2

FAULTING_IP: 
e22w7x64+6c8f
fffff880`06dd6c8f 488b08          mov     rcx,qword ptr [rax]

CUSTOMER_CRASH_COUNT:  1

DEFAULT_BUCKET_ID:  VISTA_DRIVER_FAULT

BUGCHECK_STR:  0xD1

PROCESS_NAME:  ThunderPlatfor

TRAP_FRAME:  fffff8801099d660 -- (.trap 0xfffff8801099d660)
NOTE: The trap frame does not contain all registers.
Some register values may be zeroed or incorrect.
rax=0000000000000000 rbx=0000000000000000 rcx=00000000000015f2
rdx=0000000000000000 rsi=0000000000000000 rdi=0000000000000000
rip=fffff88006dd6c8f rsp=fffff8801099d7f0 rbp=fffffa800c539f58
 r8=000000000000009b  r9=fffffa800c3e3000 r10=00000000000fffff
r11=fffff8801099d810 r12=0000000000000000 r13=0000000000000000
r14=0000000000000000 r15=0000000000000000
iopl=0         nv up ei pl nz na pe nc
e22w7x64+0x6c8f:
fffff880`06dd6c8f 488b08          mov     rcx,qword ptr [rax] ds:ae0e:00000000`00000000=????????????????
Resetting default scope

LAST_CONTROL_TRANSFER:  from fffff800042d6fe9 to fffff800042d7a40

STACK_TEXT:  
fffff880`1099d518 fffff800`042d6fe9 : 00000000`0000000a 00000000`00000000 00000000`00000002 00000000`00000000 : nt!KeBugCheckEx
fffff880`1099d520 fffff800`042d5c60 : 00000000`00000002 00000000`0000002a fffffa80`07456240 00000000`00000001 : nt!KiBugCheckDispatch+0x69
fffff880`1099d660 fffff880`06dd6c8f : fffffa80`0c3db880 00000000`00000000 00000000`00000000 00000000`00000000 : nt!KiPageFault+0x260
fffff880`1099d7f0 fffffa80`0c3db880 : 00000000`00000000 00000000`00000000 00000000`00000000 fffffa80`0c3db880 : e22w7x64+0x6c8f
fffff880`1099d7f8 00000000`00000000 : 00000000`00000000 00000000`00000000 fffffa80`0c3db880 fffffa80`0c51c870 : 0xfffffa80`0c3db880


STACK_COMMAND:  kb

FOLLOWUP_IP: 
e22w7x64+6c8f
fffff880`06dd6c8f 488b08          mov     rcx,qword ptr [rax]

SYMBOL_STACK_INDEX:  3

SYMBOL_NAME:  e22w7x64+6c8f

FOLLOWUP_NAME:  MachineOwner

MODULE_NAME: e22w7x64

IMAGE_NAME:  e22w7x64.sys

DEBUG_FLR_IMAGE_TIMESTAMP:  5332f945

FAILURE_BUCKET_ID:  X64_0xD1_e22w7x64+6c8f

BUCKET_ID:  X64_0xD1_e22w7x64+6c8f

Followup: MachineOwner
---------





问题签名:
  问题事件名称: BlueScreen
  OS 版本: 6.1.7601.2.1.0.256.1
  区域设置 ID: 2052

有关该问题的其他信息:
  BCCode: d1
  BCP1: 0000000000000000
  BCP2: 0000000000000002
  BCP3: 0000000000000000
  BCP4: FFFFF88006DD6C8F
  OS Version: 6_1_7601
  Service Pack: 1_0
  Product: 256_1

有助于描述该问题的文件:
  C:\Windows\Minidump\040315-13665-01.dmp
  C:\Users\async\AppData\Local\Temp\WER-15194-0.sysdata.xml

联机阅读隐私声明:
  http://go.microsoft.com/fwlink/?linkid=104288&clcid=0x0804

如果无法获取联机隐私声明，请脱机阅读我们的隐私声明:
  C:\Windows\system32\zh-CN\erofflps.txt



05-03

Microsoft (R) Windows Debugger Version 6.12.0002.633 X86
Copyright (c) Microsoft Corporation. All rights reserved.


Loading Dump File [C:\Windows\Minidump\050215-14476-01.dmp]
Mini Kernel Dump File: Only registers and stack trace are available

WARNING: Whitespace at end of path element
Symbol search path is: SRV*DownstreamStore*http://msdl.microsoft.com/download/symbols
Executable search path is:
Windows 7 Kernel Version 7601 (Service Pack 1) MP (4 procs) Free x64
Product: WinNt, suite: TerminalServer SingleUserTS
Built by: 7601.18798.amd64fre.win7sp1_gdr.150316-1654
Machine Name:
Kernel base = 0xfffff800`04217000 PsLoadedModuleList = 0xfffff800`0445c890
Debug session time: Sat May  2 23:54:33.461 2015 (UTC + 8:00)
System Uptime: 0 days 4:41:17.788
Loading Kernel Symbols
...............................................................
................................................................
.......................................
Loading User Symbols
Loading unloaded module list
......................
*******************************************************************************
*                                                                             *
*                        Bugcheck Analysis                                    *
*                                                                             *
*******************************************************************************

Use !analyze -v to get detailed debugging information.

BugCheck D1, {100000010325, 2, 0, fffff880071e4ad6}

Unable to load image \SystemRoot\system32\DRIVERS\e22w7x64.sys, Win32 error 0n2
*** WARNING: Unable to verify timestamp for e22w7x64.sys
*** ERROR: Module load completed but symbols could not be loaded for e22w7x64.sys
Probably caused by : e22w7x64.sys ( e22w7x64+6ad6 )

Followup: MachineOwner
---------

0: kd> !analyze -v
*******************************************************************************
*                                                                             *
*                        Bugcheck Analysis                                    *
*                                                                             *
*******************************************************************************

DRIVER_IRQL_NOT_LESS_OR_EQUAL (d1)
An attempt was made to access a pageable (or completely invalid) address at an
interrupt request level (IRQL) that is too high.  This is usually
caused by drivers using improper addresses.
If kernel debugger is available get stack backtrace.
Arguments:
Arg1: 0000100000010325, memory referenced
Arg2: 0000000000000002, IRQL
Arg3: 0000000000000000, value 0 = read operation, 1 = write operation
Arg4: fffff880071e4ad6, address which referenced memory

Debugging Details:
------------------


READ_ADDRESS: GetPointerFromAddress: unable to read from fffff800044c6100
0000100000010325

CURRENT_IRQL:  2

FAULTING_IP:
e22w7x64+6ad6
fffff880`071e4ad6 448b4a28        mov     r9d,dword ptr [rdx+28h]

CUSTOMER_CRASH_COUNT:  1

DEFAULT_BUCKET_ID:  VISTA_DRIVER_FAULT

BUGCHECK_STR:  0xD1

PROCESS_NAME:  ThunderPlatfor

TRAP_FRAME:  fffff8800e0de880 -- (.trap 0xfffff8800e0de880)
NOTE: The trap frame does not contain all registers.
Some register values may be zeroed or incorrect.
rax=0000000000005051 rbx=0000000000000000 rcx=0000000000000000
rdx=00001000000102fd rsi=0000000000000000 rdi=0000000000000000
rip=fffff880071e4ad6 rsp=fffff8800e0dea18 rbp=fffffa800c440c20
r8=0000000000005051  r9=0000000000005050 r10=0000000000000fff
r11=fffff8800e0de7c0 r12=0000000000000000 r13=0000000000000000
r14=0000000000000000 r15=0000000000000000
iopl=0         nv up ei pl nz na pe nc
e22w7x64+0x6ad6:
fffff880`071e4ad6 448b4a28        mov     r9d,dword ptr [rdx+28h] ds:d8d8:00001000`00010325=????????
Resetting default scope

LAST_CONTROL_TRANSFER:  from fffff80004288fe9 to fffff80004289a40

STACK_TEXT: 
fffff880`0e0de738 fffff800`04288fe9 : 00000000`0000000a 00001000`00010325 00000000`00000002 00000000`00000000 : nt!KeBugCheckEx
fffff880`0e0de740 fffff800`04287c60 : fffff880`071e4e18 00000000`00000000 00000000`00000001 fffffa80`0c823a00 : nt!KiBugCheckDispatch+0x69
fffff880`0e0de880 fffff880`071e4ad6 : fffff880`071e5014 fffffa80`0c823a20 fffffa80`0c823000 fffffa80`0dbafae0 : nt!KiPageFault+0x260
fffff880`0e0dea18 fffff880`071e5014 : fffffa80`0c823a20 fffffa80`0c823000 fffffa80`0dbafae0 fffffa80`0c440c20 : e22w7x64+0x6ad6
fffff880`0e0dea20 fffffa80`0c823a20 : fffffa80`0c823000 fffffa80`0dbafae0 fffffa80`0c440c20 fffffa80`0c95ec40 : e22w7x64+0x7014
fffff880`0e0dea28 fffffa80`0c823000 : fffffa80`0dbafae0 fffffa80`0c440c20 fffffa80`0c95ec40 fffffa80`000001c0 : 0xfffffa80`0c823a20
fffff880`0e0dea30 fffffa80`0dbafae0 : fffffa80`0c440c20 fffffa80`0c95ec40 fffffa80`000001c0 00000000`00000000 : 0xfffffa80`0c823000
fffff880`0e0dea38 fffffa80`0c440c20 : fffffa80`0c95ec40 fffffa80`000001c0 00000000`00000000 00000000`00000000 : 0xfffffa80`0dbafae0
fffff880`0e0dea40 fffffa80`0c95ec40 : fffffa80`000001c0 00000000`00000000 00000000`00000000 00000000`00000000 : 0xfffffa80`0c440c20
fffff880`0e0dea48 fffffa80`000001c0 : 00000000`00000000 00000000`00000000 00000000`00000000 fffffa80`13ceb870 : 0xfffffa80`0c95ec40
fffff880`0e0dea50 00000000`00000000 : 00000000`00000000 00000000`00000000 fffffa80`13ceb870 fffffa80`0dbafae0 : 0xfffffa80`000001c0


STACK_COMMAND:  kb

FOLLOWUP_IP:
e22w7x64+6ad6
fffff880`071e4ad6 448b4a28        mov     r9d,dword ptr [rdx+28h]

SYMBOL_STACK_INDEX:  3

SYMBOL_NAME:  e22w7x64+6ad6

FOLLOWUP_NAME:  MachineOwner

MODULE_NAME: e22w7x64

IMAGE_NAME:  e22w7x64.sys

DEBUG_FLR_IMAGE_TIMESTAMP:  5332f945

FAILURE_BUCKET_ID:  X64_0xD1_e22w7x64+6ad6

BUCKET_ID:  X64_0xD1_e22w7x64+6ad6

Followup: MachineOwner
---------
