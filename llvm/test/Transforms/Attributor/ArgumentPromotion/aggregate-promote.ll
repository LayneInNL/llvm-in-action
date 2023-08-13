; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=5 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=5 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

%T = type { i32, i32, i32, i32 }
@G = constant %T { i32 0, i32 0, i32 17, i32 25 }

;.
; CHECK: @[[G:[a-zA-Z0-9_$"\\.-]+]] = constant [[T:%.*]] { i32 0, i32 0, i32 17, i32 25 }
;.
define internal i32 @test(%T* %p) {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@test
; CHECK-SAME: () #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = load i32, i32* getelementptr inbounds ([[T:%.*]], %T* @G, i64 0, i32 3), align 4
; CHECK-NEXT:    [[B:%.*]] = load i32, i32* getelementptr inbounds ([[T]], %T* @G, i64 0, i32 2), align 8
; CHECK-NEXT:    [[V:%.*]] = add i32 [[A]], [[B]]
; CHECK-NEXT:    ret i32 [[V]]
;
entry:
  %a.gep = getelementptr %T, %T* %p, i64 0, i32 3
  %b.gep = getelementptr %T, %T* %p, i64 0, i32 2
  %a = load i32, i32* %a.gep
  %b = load i32, i32* %b.gep
  %v = add i32 %a, %b
  ret i32 %v
}

define i32 @caller() {
; IS__TUNIT____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@caller
; IS__TUNIT____-SAME: () #[[ATTR0]] {
; IS__TUNIT____-NEXT:  entry:
; IS__TUNIT____-NEXT:    [[V:%.*]] = call i32 @test() #[[ATTR1:[0-9]+]]
; IS__TUNIT____-NEXT:    ret i32 [[V]]
;
; IS__CGSCC____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@caller
; IS__CGSCC____-SAME: () #[[ATTR1:[0-9]+]] {
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    [[V:%.*]] = call i32 @test() #[[ATTR2:[0-9]+]]
; IS__CGSCC____-NEXT:    ret i32 [[V]]
;
entry:
  %v = call i32 @test(%T* @G)
  ret i32 %v
}
;.
; IS__TUNIT____: attributes #[[ATTR0]] = { nofree norecurse nosync nounwind readnone willreturn }
; IS__TUNIT____: attributes #[[ATTR1]] = { nofree nosync nounwind readnone willreturn }
;.
; IS__CGSCC____: attributes #[[ATTR0]] = { nofree norecurse nosync nounwind readnone willreturn }
; IS__CGSCC____: attributes #[[ATTR1]] = { nofree nosync nounwind readnone willreturn }
; IS__CGSCC____: attributes #[[ATTR2]] = { readnone willreturn }
;.