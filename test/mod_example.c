#include "mod_example.h"
#include <assert.h>

// good naming pattern: test_<module_name>_<function_name>__<test-case>

void test_example_module_addtion__basic() {
  assert(mod_example_addition(1,2) == 3);
  assert(mod_example_addition(2,2) != 3);
}

int main() {
  test_example_module_addtion__basic();
  return 0;
}
