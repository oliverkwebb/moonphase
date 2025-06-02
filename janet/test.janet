#!/usr/bin/env janet

(import ./moonphase :prefix "")

(defn main [& args]

  (def test |(-> (- 1 (math/cos (moonphase $)))
                 (/ 2)
                 (* 100)
                 (* 10)
                 (math/round)
                 (/ 10)))

  (def testdata [[-178070400 1.2]
                 [361411200 93.6]
                 [1704931200 0.4]
                 [2898374400 44.2]])

  (each [input expected] testdata
    (->
      (test input)
      (= expected)
      assert
      tracev)))


# Output: 
#
# ```
# trace [./test.janet]: (assert (= (test input) expected)) is true
# trace [./test.janet]: (assert (= (test input) expected)) is true
# trace [./test.janet]: (assert (= (test input) expected)) is true
# trace [./test.janet]: (assert (= (test input) expected)) is true
# ````

