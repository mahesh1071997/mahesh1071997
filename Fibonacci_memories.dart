void main() async {
  print(" ${fibonacci(50)}");
}

int fibonacci(int n, [Map<int, int>? memo]) {
  memo ??= {};
  if (memo.containsKey(n)) {
    return memo[n] ?? 0;
  }
  if (n < 2) {
    return n;
  }
  memo[n] = (fibonacci(n - 1, memo) + fibonacci(n - 2, memo));
  return memo[n] ?? 0;
}

int fibonacci1(int n) {
  if (n < 2) {
    return n;
  } else {
    return (fibonacci1(n - 1) + fibonacci1(n - 2));
  }
}
