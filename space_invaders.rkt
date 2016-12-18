;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname space_invaders) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;;****************************************************************************;;
;   *             _______..______      ___    *  ______  _______    *       *  ;
;         *      /       ||   _  \ *  /   \     /      ||   ____|              ;
;   *           |   (----`|  |_)  |  /  ^  \   |  ,----'|  |__      *     *    ;
;      *         \   \  * |   ___/  /  /_\  \  |  |  *  |   __|                ;
;            .----)   |   |  |     /  _____  \ |  `----.|  |____     *         ;
;         *  |_______/    | _|    /__/     \__\ \______||_______|           *  ;
;   *                  *                *                               *      ;
;             *                *                  *        *                   ;
; __  .__   __. ____    ____  ___   *   _______   _______ .______  *     _____.;
;|  | |  \ |  | \   \  /   / /   \     |       \ |   ____||   _  \      /     |;
;|  | |   \|  |  \   \/   / /  ^  \  * |  .--.  ||  |__ * |  |_)     * |_  (--`;
;|  | |  . `  |   \      / /  /_\  \   |  |  |  ||   __|  |      /       \   \ ;
;|  | |  |\   |  * \    / /  _____  \  |  '--'  ||  |____ |  |\  \----..--)   |;
;|__| |__| \__|     \__/ /__/     \__\ |_______/ |_______|| _| `._____||______/;
;;****************************************************************************;;
;;*****************************BY--RAHUL-THOMAS--*****************************;;
;;****************************************************************************;;

(require 2htdp/image)
(require 2htdp/universe)

;;---------------------------------CONSTANTS----------------------------------;;

(define MAX-SHIP-BULLETS 3)
(define MAX-INVADER-BULLETS 10)

(define LEFT 'left)
(define RIGHT 'right)
(define UP 'up)
(define DOWN 'down)
(define LEFT-ARROW "left")
(define RIGHT-ARROW "right")
(define SPACE " ")

(define TRUE #true)
(define FALSE #false)

(define UNIT-DECREMENT 1)
(define SINGLE-TICK 1)

(define GAME-STATE-SHIP-DEAD 'ship-dead)
(define GAME-STATE-INV-CONQ 'inv-conq)
(define GAME-STATE-VICTORY 'victory)
(define GAME-OUTCOME-LOSS 'loss)
(define GAME-OUTCOME-WIN 'win)


(define VICTORY-MESSAGE "You Have WON!!!")
(define DEFEAT-MESSAGE-SHIP-DEAD "You LOST!!! - Your Ship is DEAD")
(define DEFEAT-MESSAGE-INV-CONQ "You LOST!!! - Invaders have CONQUERED")
(define FINAL-SCORE-MESSAGE " - Final Score => ")
(define VICTORY-MESSAGE-COLOR "indigo")
(define DEFEAT-MESSAGE-COLOR "red")
(define SPLASH-FONT-SIZE 16)

(define LIVES-MESSAGE "Lives: x")
(define SCORE-MESSAGE "Score: ")
(define ON-SCREEN-FONT 12)
(define ON-SCREEN-COLOR 'purple)

(define WIDTH 500) 
(define HEIGHT 500)

(define BACKGROUND (empty-scene WIDTH HEIGHT)) ;; blank canvas to render images
(define CANVAS-CENTER 250)

(define LIFE-X 30)
(define LIFE-Y 494)
(define SCORE-X 464)
(define SCORE-Y 10)

(define POINT-PER-INVADER 5)

(define SHIP-WIDTH 25)
(define SHIP-HEIGHT 15)
(define SHIP-HALF-WIDTH (/ 25 2))
(define SHIP-HALF-HEIGHT (/ 15 2))

(define SHIP-SPEED 10)
(define SPACESHIP-IMAGE (rectangle SHIP-WIDTH SHIP-HEIGHT 'solid 'black))
(define SHIP-INIT-X-AXIS 250)
(define SHIP-Y-AXIS 480)
(define SHIP-INIT-LIVES 2)
(define SHIP-INIT-LOC (make-posn SHIP-INIT-X-AXIS SHIP-Y-AXIS))
(define SHIP-LEFT-MOV-LOC (make-posn (- 250 SHIP-SPEED) 480))
(define SHIP-RIGHT-MOV-LOC (make-posn (+ 250 SHIP-SPEED) 480))
(define SHIP-LEFT-EDGE-LOC (make-posn 15 480))
(define SHIP-LEFT-ALIGN-LOC (make-posn (+ 0 SHIP-HALF-WIDTH) 480))
(define SHIP-RIGHT-EDGE-LOC (make-posn 485 480))
(define SHIP-RIGHT-ALIGN-LOC (make-posn (- 500 SHIP-HALF-WIDTH) 480))

(define INV-SPEED 5)
(define INVADER-SIDE 20)
(define INV-HALF-SIDE (/ INVADER-SIDE 2))
(define INVADER-IMAGE (square INVADER-SIDE 'solid 'red))
(define NUM-OF-INVADERS 36)
(define MOV-TICKS 10)

(define TICKS-INIT 0)

(define SCORE-INIT 0)
(define SCORE-WIN 180)

(define BULLET-SPEED 10)
(define BULLET-RADIUS 2)
(define SPACESHIP-BULLET-IMAGE (circle BULLET-RADIUS 'solid 'black))
(define INVADER-BULLET-IMAGE (circle BULLET-RADIUS 'solid 'red))

(define LIST-OF-INVADER-IMAGES
  (list INVADER-IMAGE INVADER-IMAGE INVADER-IMAGE  INVADER-IMAGE
        INVADER-IMAGE INVADER-IMAGE INVADER-IMAGE INVADER-IMAGE
        INVADER-IMAGE INVADER-IMAGE INVADER-IMAGE INVADER-IMAGE
        INVADER-IMAGE INVADER-IMAGE INVADER-IMAGE INVADER-IMAGE
        INVADER-IMAGE INVADER-IMAGE INVADER-IMAGE INVADER-IMAGE
        INVADER-IMAGE INVADER-IMAGE INVADER-IMAGE INVADER-IMAGE
        INVADER-IMAGE INVADER-IMAGE INVADER-IMAGE INVADER-IMAGE
        INVADER-IMAGE INVADER-IMAGE INVADER-IMAGE INVADER-IMAGE
        INVADER-IMAGE INVADER-IMAGE INVADER-IMAGE INVADER-IMAGE))
(define LIST-OF-INVADERS
  (list (make-posn 100 20) (make-posn 140 20) (make-posn 180 20) 
        (make-posn 220 20) (make-posn 260 20) (make-posn 300 20) 
        (make-posn 340 20) (make-posn 380 20) (make-posn 420 20)
        (make-posn 100 50) (make-posn 140 50) (make-posn 180 50) 
        (make-posn 220 50) (make-posn 260 50) (make-posn 300 50) 
        (make-posn 340 50) (make-posn 380 50) (make-posn 420 50)
        (make-posn 100 80) (make-posn 140 80) (make-posn 180 80) 
        (make-posn 220 80) (make-posn 260 80) (make-posn 300 80) 
        (make-posn 340 80) (make-posn 380 80) (make-posn 420 80)
        (make-posn 100 110) (make-posn 140 110) (make-posn 180 110) 
        (make-posn 220 110) (make-posn 260 110) (make-posn 300 110) 
        (make-posn 340 110) (make-posn 380 110) (make-posn 420 110)))
(define LIST-OF-INVADERS-MOVED
  (list (make-posn 100 (+ 20 INV-SPEED)) (make-posn 140 (+ 20 INV-SPEED))
        (make-posn 180 (+ 20 INV-SPEED)) (make-posn 220 (+ 20 INV-SPEED))
        (make-posn 260 (+ 20 INV-SPEED)) (make-posn 300 (+ 20 INV-SPEED)) 
        (make-posn 340 (+ 20 INV-SPEED)) (make-posn 380 (+ 20 INV-SPEED))
        (make-posn 420 (+ 20 INV-SPEED)) (make-posn 100 (+ 50 INV-SPEED)) 
        (make-posn 140 (+ 50 INV-SPEED)) (make-posn 180 (+ 50 INV-SPEED)) 
        (make-posn 220 (+ 50 INV-SPEED)) (make-posn 260 (+ 50 INV-SPEED))
        (make-posn 300 (+ 50 INV-SPEED)) (make-posn 340 (+ 50 INV-SPEED))
        (make-posn 380 (+ 50 INV-SPEED)) (make-posn 420 (+ 50 INV-SPEED))
        (make-posn 100 (+ 80 INV-SPEED)) (make-posn 140 (+ 80 INV-SPEED))
        (make-posn 180 (+ 80 INV-SPEED)) (make-posn 220 (+ 80 INV-SPEED))
        (make-posn 260 (+ 80 INV-SPEED)) (make-posn 300 (+ 80 INV-SPEED)) 
        (make-posn 340 (+ 80 INV-SPEED)) (make-posn 380 (+ 80 INV-SPEED))
        (make-posn 420 (+ 80 INV-SPEED)) (make-posn 100 (+ 110 INV-SPEED)) 
        (make-posn 140 (+ 110 INV-SPEED)) (make-posn 180 (+ 110 INV-SPEED)) 
        (make-posn 220 (+ 110 INV-SPEED)) (make-posn 260 (+ 110 INV-SPEED))
        (make-posn 300 (+ 110 INV-SPEED)) (make-posn 340 (+ 110 INV-SPEED)) 
        (make-posn 380 (+ 110 INV-SPEED)) (make-posn 420 (+ 110 INV-SPEED))))
(define LOI-MOVED-FILTERED
  (list (make-posn 100 (+ 20 INV-SPEED)) (make-posn 140 (+ 20 INV-SPEED))
        (make-posn 180 (+ 20 INV-SPEED)) (make-posn 220 (+ 20 INV-SPEED))
        (make-posn 260 (+ 20 INV-SPEED)) (make-posn 300 (+ 20 INV-SPEED)) 
        (make-posn 340 (+ 20 INV-SPEED)) (make-posn 380 (+ 20 INV-SPEED))
        (make-posn 420 (+ 20 INV-SPEED)) (make-posn 100 (+ 50 INV-SPEED)) 
        (make-posn 140 (+ 50 INV-SPEED)) (make-posn 180 (+ 50 INV-SPEED)) 
        (make-posn 220 (+ 50 INV-SPEED)) (make-posn 260 (+ 50 INV-SPEED))
        (make-posn 300 (+ 50 INV-SPEED)) (make-posn 340 (+ 50 INV-SPEED))
        (make-posn 380 (+ 50 INV-SPEED)) (make-posn 420 (+ 50 INV-SPEED))
        (make-posn 100 (+ 80 INV-SPEED)) (make-posn 140 (+ 80 INV-SPEED))
        (make-posn 180 (+ 80 INV-SPEED)) (make-posn 220 (+ 80 INV-SPEED))
        (make-posn 260 (+ 80 INV-SPEED)) (make-posn 300 (+ 80 INV-SPEED)) 
        (make-posn 340 (+ 80 INV-SPEED)) (make-posn 380 (+ 80 INV-SPEED))
        (make-posn 420 (+ 80 INV-SPEED)) (make-posn 100 (+ 110 INV-SPEED)) 
        (make-posn 140 (+ 110 INV-SPEED)) (make-posn 180 (+ 110 INV-SPEED)) 
        (make-posn 220 (+ 110 INV-SPEED)) (make-posn 260 (+ 110 INV-SPEED))
        (make-posn 300 (+ 110 INV-SPEED))))
(define LIST-OF-INVADERS-FILTERED
  (list (make-posn 100 20) (make-posn 140 20) (make-posn 180 20) 
        (make-posn 220 20) (make-posn 260 20) (make-posn 300 20) 
        (make-posn 340 20) (make-posn 380 20) (make-posn 420 20)
        (make-posn 100 50) (make-posn 140 50) (make-posn 180 50) 
        (make-posn 220 50) (make-posn 260 50) (make-posn 300 50) 
        (make-posn 340 50) (make-posn 380 50) (make-posn 420 50)
        (make-posn 100 80) (make-posn 140 80) (make-posn 180 80) 
        (make-posn 220 80) (make-posn 260 80) (make-posn 300 80) 
        (make-posn 340 80) (make-posn 380 80) (make-posn 420 80)
        (make-posn 100 110) (make-posn 140 110) (make-posn 180 110) 
        (make-posn 220 110) (make-posn 260 110) (make-posn 300 110)))
(define INV-FINAL-CONQ
  (list (make-posn 100 480) (make-posn 140 480) (make-posn 180 480)))

(define LIST-OF-SHIP-BULLET-IMAGES
  (list
   SPACESHIP-BULLET-IMAGE SPACESHIP-BULLET-IMAGE SPACESHIP-BULLET-IMAGE))
(define LIST-OF-SHIP-BULLETS
  (list (make-posn 420 300) (make-posn 250 280) (make-posn 125 200)))


(define LIST-OF-INVADER-BULLET-IMAGES
  (list INVADER-BULLET-IMAGE INVADER-BULLET-IMAGE INVADER-BULLET-IMAGE
        INVADER-BULLET-IMAGE INVADER-BULLET-IMAGE INVADER-BULLET-IMAGE
        INVADER-BULLET-IMAGE INVADER-BULLET-IMAGE INVADER-BULLET-IMAGE
        INVADER-BULLET-IMAGE INVADER-BULLET-IMAGE INVADER-BULLET-IMAGE
        INVADER-BULLET-IMAGE INVADER-BULLET-IMAGE INVADER-BULLET-IMAGE))
(define LIST-OF-INVADER-BULLETS
  (list (make-posn 100 130) (make-posn 380 129) (make-posn 300 126)
        (make-posn 140 125) (make-posn 260 165) (make-posn 420 149)
        (make-posn 420 130) (make-posn 180 139) (make-posn 100 236)
        (make-posn 260 135) (make-posn 420 288) (make-posn 420 380)
        (make-posn 220 140) (make-posn 380 240) (make-posn 180 320)))
(define LOIB-MOVED
  (list (make-posn 100 140) (make-posn 380 139) (make-posn 300 136)
        (make-posn 140 135) (make-posn 260 175) (make-posn 420 159)
        (make-posn 420 140) (make-posn 180 149) (make-posn 100 246)
        (make-posn 260 145) (make-posn 420 298) (make-posn 420 390)
        (make-posn 220 150) (make-posn 380 250) (make-posn 180 330)))

(define LIST-OF-INVADER-BULLETS-HIT-SHIP
  (list (make-posn 100 130) (make-posn 380 129) (make-posn 300 126)
        (make-posn 140 125) (make-posn 260 165) (make-posn 250 480)))
(define LIST-OF-SHIP-BULLETS-HIT-LOI
  (list (make-posn 340 109) (make-posn 380 110) (make-posn 420 109)))
(define LOSB-HIT-LOI-FILTER-TEST
  (list (make-posn 340 169) (make-posn 380 210) (make-posn 420 109)))

(define BULLET-SHIP-HIT (make-posn 250 480))
(define BULLET-SHIP-MISS (make-posn 420 300))

;;-----------------------------IMAGE-CONSTANTS--------------------------------;;

(define LIVES-INIT-IMAGE
  (place-image (text "Lives: x2" ON-SCREEN-FONT ON-SCREEN-COLOR)
               LIFE-X
               LIFE-Y
               BACKGROUND))

(define SHIP-ON-CANVAS-IMAGE
  (place-image SPACESHIP-IMAGE 250 480 LIVES-INIT-IMAGE))

(define TEST-INVADERS-IMAGE
  (place-images
   LIST-OF-INVADER-IMAGES
   LIST-OF-INVADERS
   BACKGROUND))

(define SHIP-LOB-IMAGE
  (place-images
   LIST-OF-SHIP-BULLET-IMAGES
   LIST-OF-SHIP-BULLETS
   BACKGROUND))

(define INVADER-LOB-IMAGE
  (place-images
   LIST-OF-INVADER-BULLET-IMAGES
   LIST-OF-INVADER-BULLETS
   BACKGROUND))

(define SCORES-INIT-IMAGE
  (place-image (text "Score: 0" ON-SCREEN-FONT ON-SCREEN-COLOR)
               SCORE-X
               SCORE-Y
               BACKGROUND))

(define WORLD-INIT-IMAGE
  (place-image (text "Score: 0" ON-SCREEN-FONT ON-SCREEN-COLOR)
               SCORE-X
               SCORE-Y
               (place-images
                LIST-OF-INVADER-IMAGES
                LIST-OF-INVADERS
                SHIP-ON-CANVAS-IMAGE)))

(define WORLD-TEST1-IMAGE
  (place-image (text "Score: 0" ON-SCREEN-FONT ON-SCREEN-COLOR)
               SCORE-X
               SCORE-Y
               (place-images
                LIST-OF-INVADER-BULLET-IMAGES
                LIST-OF-INVADER-BULLETS
                (place-images
                 LIST-OF-SHIP-BULLET-IMAGES
                 LIST-OF-SHIP-BULLETS
                 (place-images
                  LIST-OF-INVADER-IMAGES
                  LIST-OF-INVADERS
                  SHIP-ON-CANVAS-IMAGE)))))

(define VICTORY-IMG
  (text "You Have WON!!! - Final Score => 180"
        SPLASH-FONT-SIZE
        VICTORY-MESSAGE-COLOR))

(define DEFEAT-SHIP-DEAD-IMG
  (text "You LOST!!! - Your Ship is DEAD - Final Score => 0"
        SPLASH-FONT-SIZE
        DEFEAT-MESSAGE-COLOR))

(define INV-CONQ-DEAD-IMG
  (text "You LOST!!! - Invaders have CONQUERED - Final Score => 0"
        SPLASH-FONT-SIZE
        DEFEAT-MESSAGE-COLOR))

(define FINAL-VICTORY-IMG
  (place-image VICTORY-IMG
               CANVAS-CENTER
               CANVAS-CENTER
               BACKGROUND))

(define FINAL-DEFEAT-SHIP-DEAD-IMG
  (place-image DEFEAT-SHIP-DEAD-IMG
               CANVAS-CENTER
               CANVAS-CENTER
               BACKGROUND))

(define FINAL-INV-CONQ-DEAD-IMG
  (place-image INV-CONQ-DEAD-IMG
               CANVAS-CENTER
               CANVAS-CENTER
               BACKGROUND))

;;-----------------------------DATA-DEFINITIONS-------------------------------;;

;; An Invader is a Posn 
;; INTERP: represents the location of the invader

;; A Bullet is a Posn 
;; INTERP: represents the location of a bullet

;; A Location is a Posn 
;; INTERP: represents a location of a spaceship

;; A Direction is one of: 
;; - LEFT
;; - RIGHT
;; INTERP: represent the direction of movement for the spaceship

;;; Template:
;; direction-fn : Direction -> ???
#; (define (direction-fn d)
     (cond
       [(symbol=? d LEFT) ...]
       [(symbol=? d RIGHT) ...]))

;; A GameState is one of:
;;  - GAME-STATE-SHIP-DEAD
;;  - GAME-STATE-INV-CONQ
;;  - GAME-STATE-VICTORY
;; INTERP: represents the three possible game states.

;;; Template:
;; game-state-fn : GameState -> ???
#; (define (game-state-fn gs)
     (cond
       [(symbol=? gs GAME-STATE-SHIP-DEAD) ...]
       [(symbol=? gs GAME-STATE-INV-CONQ) ...]
       [(symbol=? gs GAME-STATE-VICTORY) ...]))

;; A GameOutcome is one of:
;;  - GAME-OUTCOME-LOSS
;;  - GAME-OUTCOME-WIN
;; INTERP: represents the two possible game outcomes.

;;; Template:
;; game-outcome-fn : GameOutcome -> ???
#; (define (game-outcome-fn go)
     (cond
       [(symbol=? go GAME-OUTCOME-LOSS) ...]
       [(symbol=? go GAME-OUTCOME-WIN) ...]))

;; A KeyEvent is a String
;; INTERP: represents the different key-events generated
;;         by input on the keyboard

;; Lives is a Integer
;; INTERP: represents the number of lives the ship has left.

(define-struct ship (dir loc lives))
;; A Ship is (make-ship Direction Location Lives) 
;; INTERP: represent the spaceship with its current direction, 
;;         movement and remaining lives

;;; Template:
;; ship-fn : Ship -> ???
#; (define (ship-fn a-ship)
     ... (direction-fn (ship-dir a-ship)) ...
     ... (ship-loc a-ship) ...
     ... (ship-lives a-ship) ...)

;;; Data Examples:
(define SHIP-INIT (make-ship LEFT SHIP-INIT-LOC SHIP-INIT-LIVES))
(define SHIP-UPD1 (make-ship RIGHT SHIP-INIT-LOC SHIP-INIT-LIVES))
(define SHIP-INIT-MOVED (make-ship LEFT SHIP-LEFT-MOV-LOC SHIP-INIT-LIVES))
(define SHIP-UPD1-MOVED (make-ship RIGHT SHIP-RIGHT-MOV-LOC SHIP-INIT-LIVES))
(define SHIP-LEFT-CORNER (make-ship LEFT SHIP-LEFT-EDGE-LOC SHIP-INIT-LIVES))
(define SHIP-LEFT-ALIGN (make-ship LEFT SHIP-LEFT-ALIGN-LOC SHIP-INIT-LIVES))
(define SHIP-RIGHT-CORNER (make-ship RIGHT SHIP-RIGHT-EDGE-LOC SHIP-INIT-LIVES))
(define SHIP-RIGHT-ALIGN (make-ship RIGHT SHIP-RIGHT-ALIGN-LOC SHIP-INIT-LIVES))
(define SHIP-LIFE-LOST (make-ship LEFT SHIP-INIT-LOC 1))
(define SHIP-DEAD (make-ship LEFT SHIP-INIT-LOC -1))

;; A List of Invaders (LoI) is one of 
;; - empty 
;; - (cons Invader LoI)

;;; Template:
;; loi-fn : LoI -> ???
#; (define (loi-fn loi)
     (cond
       [(empty? loi) ...]
       [(cons? loi) ... (posn-fn(first loi)) ...
                    ... (loi-fn (rest loi)) ...]))

;;; Data Examples:
(define INVADERS-INIT LIST-OF-INVADERS)
(define INVADERS-EMPTY empty)
(define INVADERS-FINAL-CONQ INV-FINAL-CONQ)
(define LOI-FILTERED LIST-OF-INVADERS-FILTERED)
(define INVADERS-INIT-MOVED LIST-OF-INVADERS-MOVED)
(define INVADERS-INIT-MOVED-FILTERED LOI-MOVED-FILTERED)

;; A List of Bullets (LoB) is one of 
;; - empty
;; - (cons Bullet LoB)

;;; Template:
;; lob-fn : LoB -> ???
#; (define (lob-fn lob)
     (cond
       [(empty? lob) ...]
       [(cons? lob) ... (posn-fn(first lob)) ...
                    ... (lob-fn (rest lob)) ...]))

;;; Data Examples:
(define LOB-TEST1 LIST-OF-SHIP-BULLETS)
(define LOB-TEST2 LIST-OF-INVADER-BULLETS)
(define LOB-TEST3 (list (make-posn 250 480)))
(define LOB-TEST4 LIST-OF-INVADER-BULLETS-HIT-SHIP)
(define LOB-TEST5 (list (make-posn 300 350)))
(define LOB-TEST6 LIST-OF-SHIP-BULLETS-HIT-LOI)
(define LOB-TEST7 LOSB-HIT-LOI-FILTER-TEST)

(define LIST-OF-SHIP-BULLETS-MOVED
  (list (make-posn 420 290) (make-posn 250 270) (make-posn 125 190)))
(define LIST-OF-INVADER-BULLETS-MOV LOIB-MOVED)
(define LOSB-FILTER-TEST
  (list (make-posn 340 109) (make-posn 380 110) (make-posn 420 0)))
(define LOSB-FILTERED
  (list (make-posn 340 109) (make-posn 380 110)))
(define LOSB-HIT-LOI-FILTERED
  (list (make-posn 340 169) (make-posn 380 210)))
(define LOIB-FILTER-TEST
  (list (make-posn 100 130) (make-posn 380 129) (make-posn 300 126)
        (make-posn 140 505) (make-posn 260 500) (make-posn 250 510)))
(define LOIB-FILTERED
  (list (make-posn 100 130) (make-posn 380 129) (make-posn 300 126)))
(define LOI-BULLETS-FILTER-TEST
  (list (make-posn 100 130) (make-posn 380 129) (make-posn 300 126)
        (make-posn 140 125) (make-posn 260 165) (make-posn 250 480)))
(define LOI-BULLETS-FILTERED
  (list (make-posn 100 130) (make-posn 380 129) (make-posn 300 126)
        (make-posn 140 125) (make-posn 260 165)))

(define SLOB-ANIM-INIT 
	(list (make-posn 340 119) (make-posn 380 118) (make-posn 420 119)))
(define SLOB-ANIM-MOVED 
	(list (make-posn 340 109) (make-posn 380 108) (make-posn 420 109)))
(define SLOB-ANIM-MOVED-FILTERED
	(list (make-posn 340 109) (make-posn 380 108)))
(define ILOB-ANIM-INIT
  (list (make-posn 100 130) (make-posn 380 129) (make-posn 300 126)
        (make-posn 140 125) (make-posn 260 165) (make-posn 420 149)
        (make-posn 420 130) (make-posn 180 139) (make-posn 100 236)
        (make-posn 260 135) (make-posn 420 288) (make-posn 420 495)
        (make-posn 220 140) (make-posn 380 240) (make-posn 180 320)))
(define ILOB-ANIM-MOVED
  (list (make-posn 100 140) (make-posn 380 139) (make-posn 300 136)
        (make-posn 140 135) (make-posn 260 175) (make-posn 420 159)
        (make-posn 420 140) (make-posn 180 149) (make-posn 100 246)
        (make-posn 260 145) (make-posn 420 298) (make-posn 420 505)
        (make-posn 220 150) (make-posn 380 250) (make-posn 180 330)))
(define ILOB-ANIM-MOVED-OOB-FILTERED
  (list (make-posn 100 140) (make-posn 380 139) (make-posn 300 136)
        (make-posn 140 135) (make-posn 260 175) (make-posn 420 159)
        (make-posn 420 140) (make-posn 180 149) (make-posn 100 246)
        (make-posn 260 145) (make-posn 420 298) (make-posn 220 150)
        (make-posn 380 250) (make-posn 180 330)))


;; A Score is a NonNegInteger
;; INTERP: represents the running score of the game.

;; Ticks is a NonNegInteger
;; INTERP: represnts the count of elapsed ticks of the game.

(define-struct world (ship invaders ship-bullets invader-bullets score ticks))
;; A World is (make-world Ship LoI LoB LoB Score Ticks) 
;; INTERP: represent the ship, the current list of invaders, the inflight 
;;         spaceship bullets, the inflight invader bullets, the game score
;;         and the game ticks.

;;; Template:
;; world-fn : World -> ???
#; (define (world-fn a-world)
     ... (ship-fn (world-ship a-world)) ...
     ... (loi-fn (world-invaders a-world)) ...
     ... (lob-fn (world-ship-bullets a-world)) ...
     ... (lob-fn (world-invader-bullets a-world)) ...
     ... (world-score a-world) ...
     ... (world-ticks a-world) ...)

;;; Data Examples:
(define WORLD-INIT
  (make-world SHIP-INIT INVADERS-INIT empty empty SCORE-INIT 0))
(define WORLD-TEST1
  (make-world SHIP-INIT INVADERS-INIT LOB-TEST1 LOB-TEST2 SCORE-INIT 0))
(define WORLD-UPD-TEST1
  (make-world SHIP-UPD1 INVADERS-INIT empty empty SCORE-INIT 0))
(define WORLD-UPD-TEST2
  (make-world SHIP-INIT INVADERS-INIT LOB-TEST3 empty SCORE-INIT 0))
(define WORLD-VICTORY-STATE
  (make-world SHIP-INIT empty empty empty SCORE-WIN 500))
(define WORLD-DEFEAT-STATE-SHIP-DEAD
  (make-world SHIP-DEAD INVADERS-INIT LOB-TEST1 LOB-TEST2 SCORE-INIT 300))
(define WORLD-DEFEAT-STATE-INV-CONQ
  (make-world SHIP-LEFT-ALIGN INVADERS-FINAL-CONQ empty empty SCORE-INIT 740))


(define WORLD-ANIM-INIT
  (make-world
   SHIP-INIT INVADERS-INIT SLOB-ANIM-INIT ILOB-ANIM-INIT SCORE-INIT 9))
(define WORLD-ANIM-STATE1
  (make-world
   SHIP-INIT-MOVED INVADERS-INIT SLOB-ANIM-INIT ILOB-ANIM-INIT SCORE-INIT 9))
(define WORLD-ANIM-STATE2
  (make-world
   SHIP-INIT-MOVED INVADERS-INIT SLOB-ANIM-MOVED ILOB-ANIM-MOVED SCORE-INIT 10))
(define WORLD-ANIM-STATE3
  (make-world
   SHIP-INIT-MOVED
   INVADERS-INIT-MOVED
   SLOB-ANIM-MOVED
   ILOB-ANIM-MOVED
   SCORE-INIT
   10))
(define WORLD-ANIM-STATE4
  (make-world
   SHIP-INIT-MOVED
   INVADERS-INIT-MOVED-FILTERED
   empty
   ILOB-ANIM-MOVED
   SCORE-INIT
   10))
(define WORLD-ANIM-STATE5
  (make-world
   SHIP-INIT-MOVED
   INVADERS-INIT-MOVED-FILTERED
   empty
   ILOB-ANIM-MOVED-OOB-FILTERED
   15
   10))


;;-----------------------------ON-DRAW-FUNCTIONS------------------------------;;

;;; Signature:
;; world-draw : World -> Image

;;; Purpose: Given a world, render the image of the world containing the ship,
;;           invaders, ship-bullets, invader-bullets and the score.

;;; Strategy: composing simple functions

;;; Function Definition:
(define (world-draw world)
  (draw-scores
   world
   (draw-invader-bullets
    world
    (draw-ship-bullets
     world
     (draw-invaders
      world
      (draw-ship world))))))

;;; Tests:
(check-expect (world-draw WORLD-INIT) WORLD-INIT-IMAGE)
(check-expect (world-draw WORLD-TEST1) WORLD-TEST1-IMAGE)

;;; Signature:
;; draw-ship : World -> Image

;;; Purpose: Given a world, return the image of its ship on a canvas.

;;; Strategy: structural decomposition

;;; Function Definition:
(define (draw-ship a-world)
  (draw-ship-helper (world-ship a-world)))

;;; Tests:
(check-expect (draw-ship WORLD-INIT) SHIP-ON-CANVAS-IMAGE)


;;; Signature:
;; draw-ship-helper : Ship -> Image

;;; Purpose: Given a ship, render it as an image on a canvas.

;;; Strategy: structural decomposition

;;; Function Definition:
(define (draw-ship-helper a-ship)
  (place-image SPACESHIP-IMAGE
               (posn-x (ship-loc a-ship))
               (posn-y (ship-loc a-ship))
               (draw-lives (ship-lives a-ship))))

;;; Tests:
(check-expect (draw-ship-helper SHIP-INIT) SHIP-ON-CANVAS-IMAGE)


;;; Signature:
;; draw-lives : Lives -> Image

;;; Purpose: Given a ship's lives, render it as an image on a blank canvas

;;; Strategy: composing simple functions

;;; Function Definition:
(define (draw-lives lives)
  (place-image (make-text-image LIVES-MESSAGE lives)
               LIFE-X
               LIFE-Y
               BACKGROUND))

;;; Tests:
(check-expect (draw-lives SHIP-INIT-LIVES) LIVES-INIT-IMAGE)


;;; Signature
;; make-text-image: String Integer -> Image

;;; Purpose: Given a string and non-negative integer
;;           append them and return the text image of it

;;; Strategy: composing simple functions

;;; Function Definition:
(define (make-text-image string num)
  (text (string-append string (number->string num))
        ON-SCREEN-FONT
        ON-SCREEN-COLOR))

;;; Tests:
(check-expect (make-text-image "Lives: x" 2)
              (text "Lives: x2" ON-SCREEN-FONT ON-SCREEN-COLOR))


;;; Signature:
;; draw-invaders : World Image -> Image

;;; Purpose: Given a world and a canvas, render the images of the invaders
;;           on the canvas.

;;; Strategy: structural decomposition

;;; Function Definition:
(define (draw-invaders a-world canvas)
  (foldl (λ (invader canvas)  ;; [Invader Image -> Image]
           (place-image INVADER-IMAGE (posn-x invader) (posn-y invader) canvas))
         canvas
         (world-invaders a-world)))

;;; Tests:
(check-expect (draw-invaders WORLD-INIT BACKGROUND) TEST-INVADERS-IMAGE)


;;; Signature:
;; draw-ship-bullets : World Image -> Image

;;; Purpose: Given a world and a canvas, render the images of the ship's 
;;           bullets on the canvas.

;;; Strategy: using higher order functions

;;; Function Definition:
(define (draw-ship-bullets a-world canvas)
  (foldl (λ (bullet canvas)  ;; [Bullet Image -> Image]
           (place-image
            SPACESHIP-BULLET-IMAGE (posn-x bullet) (posn-y bullet) canvas))
         canvas
         (world-ship-bullets a-world)))

;;; Tests:
(check-expect (draw-ship-bullets WORLD-TEST1 BACKGROUND) SHIP-LOB-IMAGE)


;;; Signature:
;; draw-invader-bullets : World Image -> Image

;;; Purpose: Given a world and a canvas, render the images of the invaders's 
;;           bullets on the canvas.

;;; Strategy: using higher order functions

;;; Function Definition:
(define (draw-invader-bullets a-world canvas)
  (foldl (λ (bullet canvas)  ;; [Bullet Image -> Image]
           (place-image
            INVADER-BULLET-IMAGE (posn-x bullet) (posn-y bullet) canvas))
         canvas
         (world-invader-bullets a-world)))

;;; Tests:
(check-expect
 (draw-invader-bullets WORLD-TEST1 BACKGROUND) INVADER-LOB-IMAGE)


;;; Signature
;; draw-scores: World Image -> Image

;;; Purpose: Given a world and a image
;;           draw the scores on top-right corner and return it

;;; Strategy: composing simple functions

;;; Function Definition:
(define (draw-scores a-world canvas)
  (place-image (make-text-image SCORE-MESSAGE (world-score a-world))
               SCORE-X
               SCORE-Y
               canvas))

;;; Tests:
(check-expect (draw-scores WORLD-INIT BACKGROUND) SCORES-INIT-IMAGE)


;;------------------------------ON-KEY-FUNCTIONS------------------------------;;

;;; Signature:
;; ship-control-handler : World KeyEvent -> World

;;; Purpose: Given a world and a key event, handle the ship controls and return
;;           the updated world.

;;; Strategy: cases analysis on variable key-event

;;; Function Definition:
(define (ship-control-handler a-world key-event)
  (cond
    [(key=? key-event LEFT-ARROW) (world-ship-dir-alter a-world LEFT)]
    [(key=? key-event RIGHT-ARROW) (world-ship-dir-alter a-world RIGHT)]
    [(key=? key-event SPACE) (fire-ship-bullet a-world)]
    [else a-world]))

;;; Tests:
(check-expect (ship-control-handler WORLD-INIT "left") WORLD-INIT)
(check-expect (ship-control-handler WORLD-INIT "right") WORLD-UPD-TEST1)
(check-expect (ship-control-handler WORLD-INIT " ") WORLD-UPD-TEST2)
(check-expect (ship-control-handler WORLD-INIT "s") WORLD-INIT)

;;; Signature:
;; world-ship-dir-alter : World Direction -> World

;;; Purpose: Given a world and a direction, return a world with its ship's
;;           direction modified as per the given direction.

;;; Strategy: structural decomposition

;;; Function Definition:
(define (world-ship-dir-alter a-world direction)
  (make-world (ship-dir-alter (world-ship a-world) direction)
              (world-invaders a-world)
              (world-ship-bullets a-world)
              (world-invader-bullets a-world)
              (world-score a-world)
              (world-ticks a-world)))

;;; Tests:
(check-expect (world-ship-dir-alter WORLD-INIT LEFT) WORLD-INIT)
(check-expect (world-ship-dir-alter WORLD-INIT RIGHT) WORLD-UPD-TEST1)

;;; Signature:
;; ship-dir-alter : Ship Direction -> Ship

;;; Purpose: Given a ship and a direction, return a ship with hits direction
;;           updated accordingly.

;;; Strategy: structural decomposition

;;; Function Definition:
(define (ship-dir-alter a-ship direction)
  (make-ship direction
             (ship-loc a-ship)
             (ship-lives a-ship)))

;;; Tests:
(check-expect (ship-dir-alter SHIP-INIT RIGHT) SHIP-UPD1)
(check-expect (ship-dir-alter SHIP-UPD1 LEFT) SHIP-INIT)

;;; Signature:
;; fire-ship-bullet : World -> World

;;; Purpose: Given a world, return the world with a new bullet added to its 
;;           ship's list of bullets.

;;; Strategy: structural decomposition

;;; Function Definition:
(define (fire-ship-bullet a-world)
  (make-world (world-ship a-world)
              (world-invaders a-world)
              (add-to-ship-bullets
               (world-ship a-world) (world-ship-bullets a-world))
              (world-invader-bullets a-world)
              (world-score a-world)
              (world-ticks a-world)))

;;; Tests:
(check-expect (fire-ship-bullet WORLD-INIT) WORLD-UPD-TEST2)
(check-expect (fire-ship-bullet WORLD-TEST1) WORLD-TEST1)

;;; Signature:
;; add-to-ship-bullets : Ship LoB -> LoB

;;; Purpose: Given a list of bullets, return the list with a new bullet
;;           spawned at the position of the ship if the maximum limit
;;           for ship bullets is not exceeded.

;;; Strategy: appling template of LoB

;;; Function Definition:
(define (add-to-ship-bullets a-ship ship-lob)
  (cond
    [(>= (list-length ship-lob) MAX-SHIP-BULLETS) ship-lob]
    [else (cons (ship-loc a-ship) ship-lob)]))

;;; Tests:
(check-expect (add-to-ship-bullets SHIP-INIT empty) LOB-TEST3)
(check-expect
 (add-to-ship-bullets SHIP-INIT LIST-OF-SHIP-BULLETS) LIST-OF-SHIP-BULLETS)

;;; Signature:
;; list-length: Lof[X] -> NonNegInt

;;; Purpose: Given a list, return the count of the elements
;;           in the list.

;;; Strategy: composing simple functions

;;; Function Definition:
(define (list-length a-lob)
  (cond
    [(empty? a-lob) 0]
    [else (+ 1 (list-length (rest a-lob)))]))

;;; Tests:
(check-expect (list-length empty) 0)
(check-expect (list-length (list 1 2 3 5 6)) 5)
(check-expect (list-length (list (make-posn 100 200) (make-posn 3 5))) 2)


;;-----------------------------ON-TICK-FUNCTIONS------------------------------;;

;;********************************MOVING-SHIP*********************************;;

;;; Signature:
;; move-spaceship : Ship -> Ship

;;; Purpose: move the ship in the appropriate direction

;;; Strategy: cases on ship's Direction

;;; Function Definition:
(define (move-spaceship a-ship)
  (cond
    [(symbol=? (ship-dir a-ship) LEFT)
     (make-ship LEFT
                (move-ship-left (ship-loc a-ship))
                (ship-lives a-ship))]
    [(symbol=? (ship-dir a-ship) RIGHT)
     (make-ship RIGHT
                (move-ship-right (ship-loc a-ship))
                (ship-lives a-ship))]))

;;; Tests:
(check-expect (move-spaceship SHIP-INIT) SHIP-INIT-MOVED)
(check-expect (move-spaceship SHIP-UPD1) SHIP-UPD1-MOVED)
(check-expect (move-spaceship SHIP-LEFT-CORNER) SHIP-LEFT-ALIGN)
(check-expect (move-spaceship SHIP-RIGHT-CORNER) SHIP-RIGHT-ALIGN)


;;; Signature:
;; move-ship-left : Location -> Location

;;; Purpose: Given a location, return a new location which is moved speed units
;;           to the left

;;; Strategy: structural decomposition

;;; Function Definition:
(define (move-ship-left a-loc)
  (cond
    [(< (- (- (posn-x a-loc) SHIP-HALF-WIDTH) SHIP-SPEED) 0)
     (make-posn (+ 0 SHIP-HALF-WIDTH) (posn-y a-loc))]
    [else
     (make-posn (- (posn-x a-loc) SHIP-SPEED) (posn-y a-loc))]))

;;; Tests:
(check-expect (move-ship-left SHIP-INIT-LOC) SHIP-LEFT-MOV-LOC)
(check-expect (move-ship-left SHIP-LEFT-EDGE-LOC) SHIP-LEFT-ALIGN-LOC)

;;; Signature:
;; move-ship-right : Location -> Location

;;; Purpose: Given a location, return a new location which is moved speed units
;;           to the right

;;; Strategy: structural decomposition

;;; Function Definition:
(define (move-ship-right a-loc)
  (cond
    [(> (+ (+ (posn-x a-loc) SHIP-HALF-WIDTH) SHIP-SPEED) WIDTH)
     (make-posn (- WIDTH SHIP-HALF-WIDTH) (posn-y a-loc))]
    [else
     (make-posn (+ (posn-x a-loc) SHIP-SPEED) (posn-y a-loc))]))

;;; Tests:
(check-expect (move-ship-right SHIP-INIT-LOC) SHIP-RIGHT-MOV-LOC)
(check-expect (move-ship-right SHIP-RIGHT-EDGE-LOC) SHIP-RIGHT-ALIGN-LOC)

;;**************************FIRING-INVADER-BULLETS****************************;;

;;; Signature:
;; add-to-invader-bullets : LoI LoB -> LoB

;;; Purpose: Given a list of invaders and a list of bullets, return a new list
;;           bullets containing a new element representing a new bullet.

;;; Strategy: cases on count of LoB

;;; Function Definition:
(define (add-to-invader-bullets a-loi a-lob)
  (cond
    [(or (>= (list-length a-lob) MAX-INVADER-BULLETS)
         (<= (list-length a-loi) 0)) a-lob]
    [else (cons (gen-new-bullet a-loi (random (list-length a-loi))) a-lob)]))

;;; Tests:
(check-expect
 (add-to-invader-bullets INVADERS-INIT LIST-OF-INVADER-BULLETS)
 LIST-OF-INVADER-BULLETS)
(check-expect (add-to-invader-bullets empty LOB-TEST3) LOB-TEST3)
(check-random
 (add-to-invader-bullets INVADERS-INIT LOB-TEST3)
 (cons
  (gen-new-bullet INVADERS-INIT
                  (random (list-length INVADERS-INIT))) LOB-TEST3))

;;; Signature:
;; gen-new-bullet : LoI NonNegInteger -> Posn

;;; Purpose: Given a list of invaders and an index, return the invader at
;;           that index position
;;    WHERE: index <= size of a-loi

;;; Strategy: case analysis on the variable index

;;; Function Definition:
(define (gen-new-bullet a-loi index)
  (cond
    [(= 0 index) (first a-loi)]
    [else (gen-new-bullet (rest a-loi) (- index UNIT-DECREMENT))]))

;;; Tests:
(check-expect (gen-new-bullet INVADERS-INIT 0) (make-posn 100 20))
(check-expect (gen-new-bullet INVADERS-INIT 1) (make-posn 140 20))
(check-expect (gen-new-bullet INVADERS-INIT 20) (make-posn 180 80))

;;**************************MOVING-SHIP-&-INVADER-LOB*************************;;

;;; Signature
;; move-ship-bullets : LoB -> LoB

;;; Purpose: Given a list of ship bullets
;;           move each bullets up and return the list

(define (move-ship-bullets s-lob)
  (map (λ (bullet)  ;; [Bullet -> Bullet]
         (make-posn
          (posn-x bullet)
          (- (posn-y bullet) BULLET-SPEED)))
       s-lob))

;;; Tests:
(check-expect (move-ship-bullets empty) empty)
(check-expect
 (move-ship-bullets LIST-OF-SHIP-BULLETS) LIST-OF-SHIP-BULLETS-MOVED)

;;; Signature
;; move-invader-bullets : LoB -> LoB

;;; Purpose: Given a list of invader bullets
;;           move each bullets down 1 unit and return the list

(define (move-invader-bullets i-lob)
  (map (λ (bullet)  ;; [Bullet -> Bullet]
         (make-posn
          (posn-x bullet)
          (+ (posn-y bullet) BULLET-SPEED)))
       i-lob))

;;; Tests:
(check-expect (move-invader-bullets empty) empty)
(check-expect
 (move-invader-bullets LIST-OF-INVADER-BULLETS) LIST-OF-INVADER-BULLETS-MOV)

;;***************************FILTERING-HIT-INVADERS***************************;;

;;; Signature:
;; invaders-filter : LoI LoB -> LoI

;;; Purpose: Given a list of invaders and the list of ship bullets, remove the
;;           invaders hit by ship bullets and return the remaining list of
;;           invaders.

;;; Strategy: using template of LoI

;;; Function Definition:
(define (invaders-filter loi lob)
  (filter (λ (invader)  ;; [Invader -> Boolean]
            (not (lob-inv-hit? invader lob))) loi))


;;; Tests:
(check-expect
 (invaders-filter INVADERS-INIT LIST-OF-SHIP-BULLETS) INVADERS-INIT)
(check-expect
 (invaders-filter INVADERS-INIT LIST-OF-SHIP-BULLETS-HIT-LOI)
 LIST-OF-INVADERS-FILTERED)

;;; Signature:
;; lob-inv-hit? : Invader LoB -> Boolean

;;; Purpose: Given an invader and a list of bullets, determine if any of the
;;           bullets hit the invader.

;;; Strategy: using template of LoB

;;; Function Definition:
(define (lob-inv-hit? inv lob)
  (ormap (λ (bullet)  ;; [Bullet -> Boolean]
           (inv-hit? inv bullet)) lob))

;;; Tests:
(check-expect (lob-inv-hit? (make-posn 100 20) empty) FALSE)
(check-expect
 (lob-inv-hit? (make-posn 100 20) LIST-OF-INVADER-BULLETS) FALSE)
(check-expect
 (lob-inv-hit? (make-posn 340 110) LIST-OF-SHIP-BULLETS-HIT-LOI) TRUE)


;;; Signature:
;; inv-hit? : Invader Bullet -> Boolean

;;; Purpose: Given an invader and a bullet, determine if the invader is hit by
;;           the bullet.

;;; Strategy: composing simple functions

;;; Function Definition:
(define (inv-hit? inv a-bullet)
  (and (within-inv-side-extremes? inv a-bullet) 
       (within-inv-height-extremes? inv a-bullet)))

;;; Tests:
(check-expect (inv-hit? (make-posn 100 20) (make-posn 340 109)) FALSE)
(check-expect (inv-hit? (make-posn 340 110) (make-posn 340 109)) TRUE)

;;; Signature:
;; within-inv-side-extremes? : Invader Bullet -> Boolean

;;; Purpose: Given the invader and a bullet, check if the bullet
;;           is within the side extremes of the invader

;;; Strategy: structural decomposition

;;; Function Definition:
(define (within-inv-side-extremes? inv bullet)
  (and (> (+ (posn-x bullet) BULLET-RADIUS) (- (posn-x inv) INV-HALF-SIDE))
       (< (- (posn-x bullet) BULLET-RADIUS) (+ (posn-x inv) INV-HALF-SIDE))))

;;; Tests:
(check-expect
 (within-inv-side-extremes? (make-posn 100 20) (make-posn 340 109)) FALSE)
(check-expect
 (within-inv-side-extremes? (make-posn 340 110) (make-posn 340 109)) TRUE)

;;; Signature:
;; within-inv-height-extremes? : Invader Bullet -> Boolean

;;; Purpose: Given the invader and a bullet, check if the bullet
;;           is within the height extremes of the invader

;;; Strategy: structural decomposition

;;; Function Definition:
(define (within-inv-height-extremes? inv bullet)
  (and (> (+ (posn-y bullet) BULLET-RADIUS) (- (posn-y inv) INV-HALF-SIDE))
       (< (- (posn-y bullet) BULLET-RADIUS) (+ (posn-y inv) INV-HALF-SIDE))))

;;; Tests:
(check-expect
 (within-inv-height-extremes? (make-posn 100 20) (make-posn 340 109)) FALSE)
(check-expect
 (within-inv-height-extremes? (make-posn 340 110) (make-posn 340 109)) TRUE)

;;****************************FILTERING-OOB-LOB*******************************;;

;;; Signature:
;; within-bounds? : Posn -> Boolean

;;; Purpose: Given a posn determines if the posn lies within the constraints
;;           of the scene.

;;; Strategy: structural decomposition

;;; Function Definition:
(define (within-bounds? a-posn)
  (and (< 0 (posn-x a-posn) WIDTH)
       (< 0 (posn-y a-posn) HEIGHT)))

;;; Tests:
(check-expect (within-bounds? (make-posn 100 200)) TRUE)
(check-expect (within-bounds? (make-posn 300 -10)) FALSE)
(check-expect (within-bounds? (make-posn 100 0)) FALSE)

;;; Signature:
;; slob-oob-filter : LoB -> LoB

;;; Purpose: remove the ship's list of bullets that are out of bounds.

;;; Strategy: using higher order functions

;;; Function Definition:
(define (slob-oob-filter s-lob)
  (filter within-bounds? s-lob))

;;; Tests
(check-expect (slob-oob-filter empty) empty)
(check-expect (slob-oob-filter LIST-OF-SHIP-BULLETS) LIST-OF-SHIP-BULLETS)
(check-expect (slob-oob-filter LOSB-FILTER-TEST) LOSB-FILTERED)

;;; Signature:
;; ilob-oob-filter : LoB -> LoB

;;; Purpose: remove the invader's list of bullets that are out of bounds.

;;; Strategy: using higher order functions

;;; Function Definition:
(define (ilob-oob-filter s-lob)
  (filter within-bounds? s-lob))

;;; Tests
(check-expect (ilob-oob-filter empty) empty)
(check-expect (ilob-oob-filter LIST-OF-INVADER-BULLETS) LIST-OF-INVADER-BULLETS)
(check-expect (ilob-oob-filter LOIB-FILTER-TEST) LOIB-FILTERED)


;;**********************FILTER-SHIP-LOB-HITING-INVADERS***********************;;

;;; Signature:
;; hit-slobs-filter : LoI LoB -> LoB

;;; Purpose: Given a list of invaders and the list of ship bullets, filter
;;           out the list of bullets that have hit invaders

;;; Strategy: using template of LoB

;;; Function Definition:
(define (hit-slobs-filter loi lob)
  (filter (λ (bullet) ;; [Bullet -> Boolean]
            (not (bullet-loi-hit? loi bullet))) lob))

;;; Tests:
(check-expect
 (hit-slobs-filter LIST-OF-INVADERS LIST-OF-SHIP-BULLETS) LIST-OF-SHIP-BULLETS)
(check-expect
 (hit-slobs-filter LIST-OF-INVADERS LOB-TEST7) LOSB-HIT-LOI-FILTERED)

;;; Signature:
;; bullet-loi-hit? : LoI Bullet -> Boolean

;;; Purpose: Given a list of invaders and a bullet, determine if the bullet
;;           hit any of the invaders.

;;; Strategy: using template of LoI

;;; Function Definition:
(define (bullet-loi-hit? loi bullet)
  (ormap (λ (invader) ;; [Invader -> Boolean]
           (bullet-hit-inv? bullet invader)) loi))

;;; Tests:
(check-expect (bullet-loi-hit? empty (make-posn 100 20)) FALSE)
(check-expect (bullet-loi-hit? LIST-OF-INVADERS (make-posn 100 20)) TRUE)
(check-expect (bullet-loi-hit? LIST-OF-INVADERS (make-posn 300 200)) FALSE)
(check-expect
 (bullet-loi-hit? LIST-OF-INVADERS (make-posn 340 109)) TRUE)


;;; Signature:
;; bullet-hit-inv? : Bullet Invader -> Boolean

;;; Purpose: Given a bullet and an invader, determine if the bullet hit
;;           the invader.

;;; Strategy: composing simple functions

;;; Function Definition:
(define (bullet-hit-inv? a-bullet inv)
  (and (within-inv-side-extremes? inv a-bullet) 
       (within-inv-height-extremes? inv a-bullet)))

;;; Tests:
(check-expect (bullet-hit-inv? (make-posn 340 109) (make-posn 100 20)) FALSE)
(check-expect (bullet-hit-inv? (make-posn 340 109) (make-posn 340 110)) TRUE)

;;******************************CALC-SHIP-LIVES*******************************;;

;;; Signature:
;; calc-ship-lives : Ship LoB -> Ship

;;; Purpose: Given a ship and the list of invader bullets, calculate the number
;;           of lives left and return a new ship with the updated
;;           number of lives.

;;; Strategy: structural decomposition

;;; Function Definition:
(define (calc-ship-lives a-ship i-lob)
  (cond
    [(ship-hit? a-ship i-lob) (make-ship (ship-dir a-ship)
                                         (ship-loc a-ship)
                                         (- (ship-lives a-ship) 1))]
    [else a-ship]))


;;; Tests:
(check-expect (calc-ship-lives SHIP-INIT empty) SHIP-INIT)
(check-expect (calc-ship-lives SHIP-INIT LOB-TEST2) SHIP-INIT)
(check-expect (calc-ship-lives SHIP-INIT LOB-TEST4) SHIP-LIFE-LOST)

;;; Signature:
;; ship-hit? : Ship LoB -> Boolean

;;; Purpose: Given a ship and a list of bullets, determine if any of the 
;;           bullets in the list has hit the ship.

;;; Strategy: using higher order functions

;;; Function Definition:
(define (ship-hit? ship a-lob)
  (ormap
   (λ (bullet)  ;; [Bullet -> Boolean]
     (ship-bullet-hit? ship bullet))
   a-lob))

;;; Tests:
(check-expect (ship-hit? SHIP-INIT empty) FALSE)
(check-expect (ship-hit? SHIP-INIT LOB-TEST4) TRUE)


;;; Signature:
;; ;; ship-bullet-hit? : Ship Bullet -> Boolean

;;; Purpose: Given a ship and a bullet, determine if the bullet hit the ship.

;;; Strategy: structural decomposition

;;; Function Definition:
(define (ship-bullet-hit? a-ship a-bullet)
  (and (within-ship-side-extremes? (ship-loc a-ship) a-bullet) 
       (within-ship-height-extremes? (ship-loc a-ship) a-bullet)))

;;; Tests:
(check-expect (ship-bullet-hit? SHIP-INIT BULLET-SHIP-HIT) TRUE)
(check-expect (ship-bullet-hit? SHIP-INIT BULLET-SHIP-MISS) FALSE)

;;; Signature:
;; within-ship-side-extremes? : Location Bullet -> Boolean

;;; Purpose: Given the location of the ship and a bullet, check if the bullet
;;           is within the side extremes of the ship

;;; Strategy: composing simple functions

;;; Function Definition:
(define (within-ship-side-extremes? loc bullet)
  (and (> (+ (posn-x bullet) BULLET-RADIUS) (- (posn-x loc) SHIP-HALF-WIDTH))
       (< (- (posn-x bullet) BULLET-RADIUS) (+ (posn-x loc) SHIP-HALF-WIDTH))))

;;; Tests:
(check-expect
 (within-ship-side-extremes? SHIP-INIT-LOC BULLET-SHIP-HIT) TRUE)
(check-expect
 (within-ship-side-extremes? SHIP-INIT-LOC BULLET-SHIP-MISS) FALSE)

;;; Signature:
;; within-ship-height-extremes? : Location Bullet -> Boolean

;;; Purpose: Given the location of the ship and a bullet, check if the bullet
;;           is within the height extremes of the ship

;;; Strategy: composing simple functions

;;; Function Definition:
(define (within-ship-height-extremes? loc bullet)
  (and (> (+ (posn-y bullet) BULLET-RADIUS) (- (posn-y loc) SHIP-HALF-HEIGHT))
       (< (- (posn-y bullet) BULLET-RADIUS) (+ (posn-y loc) SHIP-HALF-HEIGHT))))

;;; Tests:
(check-expect
 (within-ship-height-extremes? SHIP-INIT-LOC BULLET-SHIP-HIT) TRUE)
(check-expect
 (within-ship-height-extremes? SHIP-INIT-LOC BULLET-SHIP-MISS) FALSE)

;;***********************FILTER-INV-LOB-HITING-SHIP***************************;;

;;; Signature:
;; hit-ilobs-filter : Ship LoB -> LoB

;;; Purpose: Given a ship and a list of bullets, remove the list of bullets that
;;           have hit the ship.

;;; Strategy: 

;;; Function Definition:
(define (hit-ilobs-filter ship i-lob)
  (filter (λ (bullet) ;; [Bullet -> Boolean]
            (not (ship-bullet-hit? ship bullet))) i-lob))

;;; Tests:
(check-expect
 (hit-ilobs-filter SHIP-INIT LIST-OF-INVADER-BULLETS) LIST-OF-INVADER-BULLETS)
(check-expect
 (hit-ilobs-filter SHIP-INIT LOI-BULLETS-FILTER-TEST) LOI-BULLETS-FILTERED)

;;********************************CALC-SCORES*********************************;;

;;; Signature:
;; calc-score : LoI -> Score

;;; Purpose: Given a list of invaders, calculate the running score
;;           of the game.

;;; Strategy: composing simple functions

;;; Function Definition:
(define (calc-score loi)
  (* (- NUM-OF-INVADERS
        (list-length loi))
     POINT-PER-INVADER))

;;; Tests:
(check-expect (calc-score  INVADERS-INIT) 0)
(check-expect (calc-score  empty) 180)
(check-expect (calc-score  LOI-FILTERED) 15)

;;*******************************MOVE-INVADERS********************************;;

;;; Signature:
;; move-invaders : LoI Ticks -> LoI

;;; Purpose: Given a list of invaders and the number of elapsed ticks, return a
;;           list of invaders that has been moved 5 units every 10 ticks

;;; Strategy: cases on the variable ticks

;;; Function Definition:
(define (move-invaders loi ticks)
  (cond
    [(= (modulo ticks MOV-TICKS) 0) (map move-invader loi)]
    [else loi]))

;;; Tests:
(check-expect (move-invaders INVADERS-INIT 5) INVADERS-INIT)
(check-expect (move-invaders INVADERS-INIT 10) INVADERS-INIT-MOVED)
(check-expect (move-invaders INVADERS-INIT-MOVED 17) INVADERS-INIT-MOVED)

;;; Signature:
;; move-invader : Invader -> Invader

;;; Purpose: Given an invader, move the invader.

;;; Strategy: structural decomposition

;;; Function Definition:
(define (move-invader invader)
  (make-posn (posn-x invader)
             (+ (posn-y invader) INV-SPEED)))

;;; Tests:
(check-expect (move-invader (make-posn 100 20)) (make-posn 100 25))
(check-expect (move-invader (make-posn 300 140)) (make-posn 300 145))

;;************************ON-TICK-WORLD-TRANSFORMATION************************;;

;-----------------------------------STEP-1-------------------------------------;

;;; Signature:
;; animate-tock1 : World -> World

;;; Purpose: Given a world, return the world after moving the ship and
;;           generating new invader bullets.

;;; Strategy: structural decomposition

;;; Function Definition:
(define (animate-tock1 a-world)
  (make-world (move-spaceship (world-ship a-world))
              (world-invaders a-world)
              (world-ship-bullets a-world)
              (add-to-invader-bullets
               (world-invaders a-world) (world-invader-bullets a-world))
              (world-score a-world)
              (world-ticks a-world)))

;;; Tests:
(check-expect (animate-tock1 WORLD-ANIM-INIT) WORLD-ANIM-STATE1)


;-----------------------------------STEP-2-------------------------------------;

;;; Signature:
;; animate-tock2 : World -> World

;;; Purpose: Given a world, return the world after moving the ship's and
;;           and invader's list of bullets and incrementing the tick.

;;; Strategy: structural decomposition

;;; Function Definition:
(define (animate-tock2 a-world)
  (make-world (world-ship a-world)
              (world-invaders a-world)
              (move-ship-bullets (world-ship-bullets a-world))
              (move-invader-bullets (world-invader-bullets a-world))
              (world-score a-world)
              (+
               (world-ticks a-world) SINGLE-TICK)))

;;; Tests:
(check-expect (animate-tock2 WORLD-ANIM-STATE1) WORLD-ANIM-STATE2)


;-----------------------------------STEP-3-------------------------------------;

;;; Signature:
;; animate-tock3 : World -> World

;;; Purpose: Given a world, return the world after calculating ship lives, 
;;           moving the invaders if required, filtering the invader
;;           bullets that have hit the ship.

;;; Strategy: structural decomposition

;;; Function Definition:
(define (animate-tock3 a-world)
  (make-world (calc-ship-lives
               (world-ship a-world) (world-invader-bullets a-world))
              (move-invaders (world-invaders a-world) (world-ticks a-world))
              (world-ship-bullets a-world)
              (hit-ilobs-filter
               (world-ship a-world) (world-invader-bullets a-world))
              (world-score a-world)
              (world-ticks a-world)))

;;; Tests:
(check-expect (animate-tock3 WORLD-ANIM-STATE2) WORLD-ANIM-STATE3)

;-----------------------------------STEP-4-------------------------------------;

;;; Signature:
;; animate-tock4 : World -> World

;;; Purpose: Given a world, return the world after filtering the invaders that 
;;           are hit by the ship's bullets, ship's bullets that have hit the
;;           invaders.

;;; Strategy: structural decomposition

;;; Function Definition:
(define (animate-tock4 a-world)
  (make-world (world-ship a-world)
              (invaders-filter
               (world-invaders a-world) (world-ship-bullets a-world))
              (hit-slobs-filter
               (world-invaders a-world) (world-ship-bullets a-world))
              (world-invader-bullets a-world)
              (world-score a-world)
              (world-ticks a-world)))

;;; Tests:
(check-expect (animate-tock4 WORLD-ANIM-STATE3) WORLD-ANIM-STATE4)

;-----------------------------------STEP-5-------------------------------------;

;;; Signature:
;; animate-tock5 : World -> World

;;; Purpose: Given a world, return the world after filtering ship's and
;;           invader's bullets that are out of bounds of the scene and
;;           calculating the score of the game.

;;; Strategy: structural decomposition

;;; Function Definition:
(define (animate-tock5 a-world)
  (make-world (world-ship a-world)
              (world-invaders a-world)
              (slob-oob-filter (world-ship-bullets a-world))
              (ilob-oob-filter (world-invader-bullets a-world))
              (calc-score (world-invaders a-world))
              (world-ticks a-world)))

;;; Tests:
(check-expect (animate-tock5 WORLD-ANIM-STATE4) WORLD-ANIM-STATE5)

;---------------------------------FINAL-STEP-----------------------------------;

;;; Signature:
;; animate-tock : World -> World

;;; Purpose: Given a world, change the world state on every tick of the clock.

;;; Strategy: composing simple functions

;;; Function Definition:
(define (animate-tock a-world)
  (animate-tock5
   (animate-tock4
    (animate-tock3
     (animate-tock2
      (animate-tock1 a-world))))))

;;; Tests:
(check-expect (animate-tock WORLD-ANIM-INIT) WORLD-ANIM-STATE5)

;;----------------------------STOP-WHEN-FUNCTIONS-----------------------------;;

;;; Signature:
;; game-end? : World -> Boolean

;;; Purpose: determines if the game has ended

;;; Strategy: composing simple functions

;;; Function Definition:
(define (game-end? world)
  (or (<= (list-length (world-invaders world)) 0)
      (ship-dead? (world-ship world))
      (invaders-conquered? (world-invaders world))))

;;; Tests:
(check-expect (game-end? WORLD-VICTORY-STATE) TRUE)
(check-expect (game-end? WORLD-DEFEAT-STATE-SHIP-DEAD) TRUE)
(check-expect (game-end? WORLD-DEFEAT-STATE-INV-CONQ) TRUE)
(check-expect (game-end? WORLD-INIT) FALSE)

;;*********************************SHIP-DEAD**********************************;;

;;; Signature:
;; ship-dead? : Ship -> Boolean

;;; Purpose: Determines if the ship has exhausted its lives

;;; Strategy: composing simple functions

;;; Function Definition:
(define (ship-dead? ship)
  (< (ship-lives ship) 0))

;;; Tests:
(check-expect (ship-dead? SHIP-INIT) FALSE)
(check-expect (ship-dead? SHIP-DEAD) TRUE)

;;****************************INVADERS-CONQUERED******************************;;

;;; Signature:
;; invaders-conquered? : LoI -> Boolean

;;; Purpose: Determines if the any of the invaders have reached the ship.

;;; Strategy: using higher order functions

;;; Function Definition:
(define (invaders-conquered? loi)
  (ormap (λ (invader) ; [Invader -> Boolean]
           (>= (posn-y invader) SHIP-Y-AXIS))
         loi))

;;; Tests:
(check-expect (invaders-conquered? INVADERS-INIT) FALSE)
(check-expect (invaders-conquered? INVADERS-FINAL-CONQ) TRUE)

;;**************************GENERATE-SPLASH-SCREEN****************************;;

;;; Signature:
;; end-game-splash : World -> Image

;;; Purpose: Given an world end state, render the appropriate splash screen.

;;; Strategy: cases on different game end conditions

;;; Function Definition:
(define (end-game-spash world)
  (cond
    [(ship-dead? (world-ship world))
     (draw-splash GAME-STATE-SHIP-DEAD (world-score world))]
    [(invaders-conquered? (world-invaders world))
     (draw-splash GAME-STATE-INV-CONQ (world-score world))]
    [else (draw-splash GAME-STATE-VICTORY (world-score world))]))

;;; Tests:
(check-expect
 (end-game-spash WORLD-VICTORY-STATE) FINAL-VICTORY-IMG)
(check-expect
 (end-game-spash WORLD-DEFEAT-STATE-SHIP-DEAD) FINAL-DEFEAT-SHIP-DEAD-IMG)
(check-expect
 (end-game-spash WORLD-DEFEAT-STATE-INV-CONQ) FINAL-INV-CONQ-DEAD-IMG)

;;; Signature:
;; draw-splash : GameState Score -> Image

;;; Purpose: Given a game state and the score, render the appropriate
;;           end game message

;;; Strategy: cases on GameState

;;; Function Definition:
(define (draw-splash state score)
  (cond
    [(symbol=? state GAME-STATE-SHIP-DEAD)
     (draw-message GAME-OUTCOME-LOSS (string-append DEFEAT-MESSAGE-SHIP-DEAD
                                                    FINAL-SCORE-MESSAGE
                                                    (number->string score)))]
    [(symbol=? state GAME-STATE-INV-CONQ)
     (draw-message GAME-OUTCOME-LOSS (string-append DEFEAT-MESSAGE-INV-CONQ
                                                    FINAL-SCORE-MESSAGE
                                                    (number->string score)))]
    [(symbol=? state GAME-STATE-VICTORY)
     (draw-message GAME-OUTCOME-WIN (string-append VICTORY-MESSAGE
                                                   FINAL-SCORE-MESSAGE
                                                   (number->string score)))]))

;;; Tests:
(check-expect (draw-splash GAME-STATE-SHIP-DEAD SCORE-INIT)
              FINAL-DEFEAT-SHIP-DEAD-IMG)
(check-expect (draw-splash GAME-STATE-INV-CONQ SCORE-INIT)
              FINAL-INV-CONQ-DEAD-IMG)
(check-expect (draw-splash GAME-STATE-VICTORY SCORE-WIN)
              FINAL-VICTORY-IMG)

;;; Signature:
;; draw-message : GameOutcome String -> Image

;;; Purpose: Given the game outcome and a string render the string to an image 
;;           based on the game outcome.

;;; Strategy: cases on GameOutcome

;;; Function Definition:
(define  (draw-message outcome message)
  (cond
    [(symbol=? outcome GAME-OUTCOME-WIN)
     (place-message (text message SPLASH-FONT-SIZE VICTORY-MESSAGE-COLOR))]
    [(symbol=? outcome GAME-OUTCOME-LOSS)
     (place-message (text message SPLASH-FONT-SIZE DEFEAT-MESSAGE-COLOR))]))

;;; Tests:
(check-expect
 (draw-message GAME-OUTCOME-WIN
               "You Have WON!!! - Final Score => 180")
 FINAL-VICTORY-IMG)
(check-expect
 (draw-message GAME-OUTCOME-LOSS
               "You LOST!!! - Your Ship is DEAD - Final Score => 0")
 FINAL-DEFEAT-SHIP-DEAD-IMG)


;;; Signature:
;; place-message : Image -> Image

;;; Purpose: Given an image, places it on the canvas

;;; Strategy: combining simple functions

;;; Function Definition:
(define (place-message text-image)
  (place-image text-image
               CANVAS-CENTER
               CANVAS-CENTER
               BACKGROUND))

;;; Tests:
(check-expect (place-message VICTORY-IMG) FINAL-VICTORY-IMG)
(check-expect (place-message DEFEAT-SHIP-DEAD-IMG) FINAL-DEFEAT-SHIP-DEAD-IMG)
(check-expect (place-message INV-CONQ-DEAD-IMG) FINAL-INV-CONQ-DEAD-IMG)


;;----------------------------BIG-BANG-FUNCTION-------------------------------;;

(big-bang WORLD-INIT
          (to-draw world-draw)
          (on-tick animate-tock 0.15)
          (on-key ship-control-handler)
          (stop-when game-end? end-game-spash))

;;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-T-H-E-*-E-N-D-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-;;
