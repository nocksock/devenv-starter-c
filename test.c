#include <assert.h>
#include <stdio.h>

void test_something() {
  assert(1 + 1 == 2);
  printf("test passed\n");
}

int main() {
  test_something();
  return 0;
}
