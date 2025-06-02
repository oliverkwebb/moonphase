(defn moonphase [unix_date]
  (def eccent 0.01678) # Eccentricity of Earth's orbit
  (def elonge 278.833540) # Ecliptic longitude of the Sun at epoch 1980.0
  (def elongp 282.596403) # Ecliptic longitude of the Sun at perigee
  (def torad (/ math/pi 180))

  (def fixangle |(-> $
                     (mod 360)
                     (+ 360)
                     (mod 360)))

  # Date within epoch
  (def Day (-> unix_date
               (/ 86400)
               (+ 2440587.5)
               (- 2444238.5)))

  # Convert from perigee co-ordinates to epoch 1980.0
  (def M (-> Day
             (* (/ 360.0 365.2422))
             (+ elonge)
             (- elongp)
             (fixangle)
             (* torad)))

  # Solve equation of Kepler
  (var e M)
  (var delta 1)
  (while (> (math/abs delta) 1e-6)
    (set delta (->> (math/sin e)
                    (* eccent)
                    (- e M)))
    (set e (->> (math/cos e)
                (* eccent)
                (- 1)
                (/ delta)
                (- e))))

  # True anomaly
  (def Ec
    (->> (/ e 2)
         (math/tan)
         (* (math/sqrt (/ (+ 1 eccent) (- 1 eccent))))
         (math/atan)
         (* 2)))

  # Sun's geocentric ecliptic longitude
  (def Lambdasun
    (-> Ec
        (* (/ 180 math/pi))
        (+ elongp)
        (fixangle)))
  # Moon's mean lonigitude at the epoch
  (def ml (->
            Day
            (* 13.1763966)
            (+ 64.975464)
            (fixangle)))

  # 349:  Mean longitude of the perigee at the epoch, Moon's mean anomaly
  (def MM (-> ml
              (- (* 0.1114041 Day) 349.383063)
              (fixangle)))
  #  Evection
  (def Ev (-> ml
              (- Lambdasun)
              (* 2)
              (- MM)
              (* torad)
              (math/sin)
              (* 1.2739)))

  # Annual equation
  (def Ae (* 0.1858 (math/sin M)))

  # Corrected anomaly
  (def MmP (->>
             (math/sin M)
             (* 0.37)
             (- (+ MM Ev) Ae)
             (* torad)))

  # Corrected longitude
  (def lP (-> (+ ml Ev)
              (+ (* 6.2886 (math/sin MmP)))
              (- Ae)
              (+ (* 0.214 (math/sin (* 2 MmP))))))

  # True longitude
  (def lPP (->>
             (- lP Lambdasun)
             (* 2 torad)
             (math/sin)
             (* 0.6583)
             (+ lP)))

  # Age of the Moon in degrees
  (def MoonAge (- lPP Lambdasun))

  (* MoonAge torad))
