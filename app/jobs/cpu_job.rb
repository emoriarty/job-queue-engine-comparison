class CpuJob < ApplicationJob
  def perform
    get_fibonacci(10000)
  end

  # create a function to get Fibonacii series
  def get_fibonacci(n)
    first_term = 0
    second_term = 1
    next_term = 0
    counter = 1
    result = []

    result.push(first_term)
    while counter <= n + 1
      if counter <= 1
        next_term = counter
      else
        result.push(next_term)
        next_term = first_term + second_term
        first_term = second_term
        second_term = next_term
      end
      counter += 1
    end
    result
  end
end
