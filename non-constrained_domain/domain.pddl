(define (domain auvs_inspection)
(:requirements :strips :typing :fluents :negative-preconditions :disjunctive-preconditions :durative-actions :duration-inequalities :universal-preconditions )
(:types
  robot
  waypoint
  robot_sensor
)

(:predicates (at ?r - robot ?wp - waypoint)
             (available ?r - robot)
             (close_to ?wpi  ?wpf - waypoint)
             (surface_point_at ?r -robot ?wp - waypoint)
             (equipped_for_soil_analysis ?r - robot ?s - robot_sensor)
             (equipped_for_rock_analysis ?r - robot ?s - robot_sensor)
             (equipped_for_camera_imaging ?r - robot ?s - robot_sensor)
             (equipped_for_cad_classification ?r - robot ?s - robot_sensor)
             (equipped_for_sonar_imaging ?r - robot ?s - robot_sensor)
             (poi_rock_analysis  ?wp - waypoint)
             (poi_soil_analysis  ?wp - waypoint)
             (poi_image_taken  ?wp - waypoint)
             (poi_target_inquired  ?wp - waypoint)
             (poi_structure_id  ?wp - waypoint)
             (explored ?wp - waypoint)  
             (robot_approached ?r - robot ?wp - waypoint)

)
(:functions (energy ?r - robot)
            (consumption ?r - robot)
            (speed ?r - robot)
            (recharge_rate ?r - robot)
            (distance ?wpi ?wpf - waypoint)
            (data_adquired ?r - robot)
            (data_capacity ?r - robot)
            (total-distance)
            
)

(:durative-action robot_navigate
:parameters (?r - robot ?wpi  ?wpf - waypoint)
:duration ( = ?duration (* (/ (distance ?wpi ?wpf) (speed ?r)) 2))
:condition (and
           (at start (available ?r))
           (at start (at ?r ?wpi))
           (at start (>= (energy ?r) (* (distance ?wpi ?wpf)(consumption ?r))))
           )
:effect (and
        (at start (decrease (energy ?r) (* (distance ?wpi ?wpf)(consumption ?r))))
        (at start (not (available ?r)))
        (at start (not (at ?r ?wpi)))
        (at end (at ?r ?wpf))
        (at end (explored ?wpf))
        (at end (available ?r))
        (at end (increase (total-distance) (distance ?wpi ?wpf)))
        )
)

(:durative-action robot_target_approach
  :parameters (?r - robot  ?wp - waypoint)
  :duration ( = ?duration 50)
  :condition (and
             (over all (at ?r ?wp))
             (at start (at ?r ?wp))
             (at start (available ?r))
             (at start (>= (energy ?r) 1)))
  :effect (and
          (at start (not (available ?r)))
          (at end (robot_approached ?r ?wp))
          (at end (available ?r))
          (at end (decrease (energy ?r) 1)))
)

(:durative-action robot_sample_soil
:parameters (?r - robot ?s - robot_sensor ?wp - waypoint)
:duration (= ?duration 20)
:condition (and
           (over all (at ?r ?wp))
           (over all (equipped_for_soil_analysis ?r ?s))
           (at start (at ?r ?wp))
           (at start (available ?r))
           (at start (>= (energy ?r) 3))
           (at start (< (data_adquired ?r) (data_capacity ?r)))
           )
:effect (and
        (at start (not (available ?r)))
        (at start (decrease (energy ?r) 3))
        (at end (poi_soil_analysis ?wp))
        (at end (available ?r))
        (at end (increase (data_adquired ?r) 1))
        )
)
(:durative-action robot_sample_rock
:parameters (?r - robot ?s - robot_sensor  ?wp - waypoint)
:duration (= ?duration 20)
:condition (and
           (over all (at ?r ?wp))
           (at start (at ?r ?wp))
           (at start (available ?r))
           (at start (equipped_for_rock_analysis ?r ?s))
           (at start (>= (energy ?r) 3))
           (at start (< (data_adquired ?r) (data_capacity ?r)))
           )
:effect (and
        (at start (not (available ?r)))
        (at start (decrease (energy ?r) 5))
        (at end (poi_rock_analysis ?wp))
        (at end (available ?r))
        (at end (increase (data_adquired ?r) 1))
        )
)

(:durative-action robot_take_image
 :parameters (?r - robot ?s - robot_sensor  ?wp - waypoint)
 :duration (= ?duration 7)
 :condition (and
            (over all (equipped_for_camera_imaging ?r ?s))
            (over all (at ?r ?wp))
            (at start (at ?r ?wp))
            (at start (available ?r))
            (at start (>= (energy ?r) 1))
            (at start (< (data_adquired ?r) (data_capacity ?r)))
            )
 :effect (and
         (at start (not (available ?r)))
         (at start (decrease (energy ?r) 1))
         (at end (poi_image_taken ?wp))
         (at end (available ?r))
         (at end (increase (data_adquired ?r) 1))
         )
)
(:durative-action robot_target_id
 :parameters (?r - robot ?s - robot_sensor ?wp - waypoint)
 :duration ( = ?duration 50)
 :condition (and
             (over all (at ?r ?wp))
             (over all (equipped_for_cad_classification ?r ?s))
             (at start (at ?r ?wp))
             (at start (available ?r))
             (at start (robot_approached ?r ?wp))
             (at start (>= (energy ?r) 2))
             (at start (< (data_adquired ?r) (data_capacity ?r)))
            )
  :effect (and
          (at start (not (available ?r)))
          (at end (poi_target_inquired ?wp))
          (at end (decrease (energy ?r) 2))
          (at end (available ?r))
          (at end (increase (data_adquired ?r) 1))
          )

)
(:durative-action robot_struture_recognition
 :parameters (?r - robot ?s - robot_sensor ?wp - waypoint)
 :duration ( = ?duration 30)
 :condition (and
             (over all (at ?r ?wp))
             (over all (equipped_for_sonar_imaging ?r ?s))
             (at start (at ?r ?wp))
             (at start (available ?r))
             (at start (>= (energy ?r) 2))
             (at start (< (data_adquired ?r) (data_capacity ?r)))
            )
  :effect (and
          (at start (not (available ?r)))
          (at end (poi_structure_id ?wp))
          (at end (decrease (energy ?r) 2))
          (at end (available ?r))
          (at end (increase (data_adquired ?r) 1))
          )

)
(:durative-action surface_point_allocation
:parameters (?r - robot ?wpi  ?wpf - waypoint)
:duration ( = ?duration 1)
:condition (and
           (over all (close_to ?wpi ?wpf))
           (over all (at ?r ?wpi))
           )
:effect (and
        (at end (surface_point_at ?r ?wpf))
        )
)

(:durative-action robot_broadcast_data
:parameters (?r - robot   ?wp - waypoint)
:duration (= ?duration 20)
:condition (and
           (over all (at ?r ?wp))
           (at start (at ?r ?wp))
           (at start (surface_point_at ?r ?wp))
           (at start (available ?r))
           (at start (>= (data_adquired ?r) (data_capacity ?r)))
           (at start (>= (energy ?r) 2))
           )
:effect (and
        (at start (not (available ?r)))
        (at end (available ?r))
        (at end (decrease (energy ?r) 2))
        (at end (assign (data_adquired ?r) 0))
        (at end (not (surface_point_at ?r ?wp)))
	 )
)
(:durative-action robot_recharge
:parameters (?r - robot  ?wp - waypoint)
:duration (= ?duration (/ (- 100 (energy ?r)) (recharge_rate ?r)))
:condition (and
          (over all (at ?r ?wp))
          (at start (at ?r ?wp))
          (at start (surface_point_at ?r ?wp))
          (at start (available ?r))
          (at start (<= (energy ?r) 80))
           )
:effect (and
        (at start (not (available ?r)))
        (at end (available ?r))
        (at end (increase (energy ?r) (* ?duration (recharge_rate ?r))))
        (at end (not (surface_point_at ?r ?wp)))
        )
)

)
