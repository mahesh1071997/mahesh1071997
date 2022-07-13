void main() async {
  var colors = <int, int>{};

  print(" ${fibonacci(4,colors)}");
  print(" ${fibonacci1(4)}");

}

int fibonacci(int n, [Map<int, int>? memo]) {
  if (n < 2) {
    return n;
  } else {
    memo![n] = (fibonacci(n - 1, memo) + fibonacci(n - 2, memo));
    return memo[n] ?? 0;
  }
}
