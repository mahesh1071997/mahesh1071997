void main() async {
  
  print(" ${fibo(10)}");
  
}
// optimal memory used 
int fibo(int n, [Map<int, int>? memo]) {
  if (n < 2) {
    return n;
  } else {
    memo ??= {};
    memo[n] = (fibo(n - 1, memo) + fibo(n - 2, memo));
    return memo[n] ?? 0;
  }
}
// normal code
int fibonacci1(int n) {
  if (n < 2) {
    return n;
  } else {
    return (fibonacci1(n - 1) + fibonacci1(n - 2));
  }
}
