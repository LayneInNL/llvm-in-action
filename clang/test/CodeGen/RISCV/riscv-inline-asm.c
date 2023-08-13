// RUN: %clang_cc1 -no-opaque-pointers -triple riscv32 -O2 -emit-llvm %s -o - \
// RUN:     | FileCheck %s
// RUN: %clang_cc1 -no-opaque-pointers -triple riscv64 -O2 -emit-llvm %s -o - \
// RUN:     | FileCheck %s

// Test RISC-V specific inline assembly constraints.

void test_I(void) {
// CHECK-LABEL: define{{.*}} void @test_I()
// CHECK: call void asm sideeffect "", "I"(i32 2047)
  asm volatile ("" :: "I"(2047));
// CHECK: call void asm sideeffect "", "I"(i32 -2048)
  asm volatile ("" :: "I"(-2048));
}

void test_J(void) {
// CHECK-LABEL: define{{.*}} void @test_J()
// CHECK: call void asm sideeffect "", "J"(i32 0)
  asm volatile ("" :: "J"(0));
}

void test_K(void) {
// CHECK-LABEL: define{{.*}} void @test_K()
// CHECK: call void asm sideeffect "", "K"(i32 31)
  asm volatile ("" :: "K"(31));
// CHECK: call void asm sideeffect "", "K"(i32 0)
  asm volatile ("" :: "K"(0));
}

float f;
double d;
void test_f(void) {
// CHECK-LABEL: define{{.*}} void @test_f()
// CHECK: [[FLT_ARG:%[a-zA-Z_0-9]+]] = load float, float* @f
// CHECK: call void asm sideeffect "", "f"(float [[FLT_ARG]])
  asm volatile ("" :: "f"(f));
// CHECK: [[FLT_ARG:%[a-zA-Z_0-9]+]] = load double, double* @d
// CHECK: call void asm sideeffect "", "f"(double [[FLT_ARG]])
  asm volatile ("" :: "f"(d));
}

void test_A(int *p) {
// CHECK-LABEL: define{{.*}} void @test_A(i32* noundef %p)
// CHECK: call void asm sideeffect "", "*A"(i32* elementtype(i32) %p)
  asm volatile("" :: "A"(*p));
}

void test_S(void) {
// CHECK-LABEL: define{{.*}} void @test_S()
// CHECK: call void asm sideeffect "", "S"(float* nonnull @f)
  asm volatile("" :: "S"(&f));
}