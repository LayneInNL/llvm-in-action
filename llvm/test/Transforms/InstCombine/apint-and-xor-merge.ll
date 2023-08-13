; NOTE: Assertions have been autogenerated by update_test_checks.py
; This test case checks that the merge of and/xor can work on arbitrary
; precision integers.

; RUN: opt < %s -passes=instcombine -S | FileCheck %s

; (x &z ) ^ (y & z) -> (x ^ y) & z
define i57 @test1(i57 %x, i57 %y, i57 %z) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[TMP61:%.*]] = xor i57 %x, %y
; CHECK-NEXT:    [[TMP7:%.*]] = and i57 [[TMP61]], %z
; CHECK-NEXT:    ret i57 [[TMP7]]
;
  %tmp3 = and i57 %z, %x
  %tmp6 = and i57 %z, %y
  %tmp7 = xor i57 %tmp3, %tmp6
  ret i57 %tmp7
}

; (x & y) ^ (x | y) -> x ^ y
define i23 @test2(i23 %x, i23 %y, i23 %z) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[TMP7:%.*]] = xor i23 %y, %x
; CHECK-NEXT:    ret i23 [[TMP7]]
;
  %tmp3 = and i23 %y, %x
  %tmp6 = or i23 %y, %x
  %tmp7 = xor i23 %tmp3, %tmp6
  ret i23 %tmp7
}
