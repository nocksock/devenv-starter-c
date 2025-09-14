#include "mod_example.h"
#include <assert.h>

// good naming pattern: test_<module_name>__<test-case>

void test_example_module__addition() {
  assert(mod_example_addition(1,2) == 3);
  assert(mod_example_addition(2,2) != 3);
}

int main() {
  test_example_module__addition();
  return 0;
}
