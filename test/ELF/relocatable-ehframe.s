# REQUIRES: x86
# RUN: llvm-mc -filetype=obj -triple=x86_64-unknown-linux %s -o %t1.o
# RUN: llvm-mc -filetype=obj -triple=x86_64-unknown-linux %p/Inputs/relocatable-ehframe.s -o %t2.o
# RUN: ld.lld -r %t1.o %t2.o -o %t
# RUN: llvm-readobj -r -s -section-data %t | FileCheck %s

# CHECK:      Name: .strtab
# CHECK-NEXT: Type: SHT_STRTAB
# CHECK-NEXT: Flags [
# CHECK-NEXT: ]
# CHECK-NEXT: Address:
# CHECK-NEXT: Offset
# CHECK-NEXT: Size: 35
# CHECK-NEXT: Link: 0
# CHECK-NEXT: Info: 0
# CHECK-NEXT: AddressAlignment: 1
# CHECK-NEXT: EntrySize: 0
# CHECK-NEXT: SectionData (
# CHECK-NEXT:   0000: 00666F6F 00626172 00646168 00666F6F  |.foo.bar.dah.foo|
# CHECK-NEXT:   0010: 31006261 72310064 61683100 5F737461  |1.bar1.dah1._sta|
# CHECK-NEXT:   0020: 727400                               |rt.|
# CHECK-NEXT: )

# CHECK:      Relocations [
# CHECK-NEXT:   Section {{.*}} .rela.eh_frame {
# CHECK-NEXT:     0x20 R_X86_64_PC32 foo 0x0
# CHECK-NEXT:     0x34 R_X86_64_PC32 bar 0x0
# CHECK-NEXT:     0x48 R_X86_64_PC32 dah 0x0
# CHECK-NEXT:     0x78 R_X86_64_PC32 foo1 0x0
# CHECK-NEXT:     0x8C R_X86_64_PC32 bar1 0x0
# CHECK-NEXT:     0xA0 R_X86_64_PC32 dah1 0x0
# CHECK-NEXT:   }
# CHECK-NEXT: ]

.section foo,"ax",@progbits
.cfi_startproc
 nop
.cfi_endproc

.section bar,"ax",@progbits
.cfi_startproc
 nop
.cfi_endproc

.section dah,"ax",@progbits
.cfi_startproc
 nop
.cfi_endproc

.text
.globl _start
_start:
 nop
