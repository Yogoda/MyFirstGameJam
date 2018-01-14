extends MeshInstance

var dir
var explForce = 0.1
var rotSpeed = rand_range(-0.1, 0.1);
var rotAxis = Vector3(rand_range(0,1), rand_range(0,1), rand_range(0,1))
var dirMod = Vector3(rand_range(- explForce, explForce), 0, rand_range(- explForce, explForce))

var blinking = false

const blinkSpeed = 10
var blinkDuration
var blinkTimer
var blinkSteps

var exploding = false

var explodeDuration = 0.5
var explodeTimer

func _ready():

#	exposion direction	
	dir = get_translation() * 0.3 + dirMod
	
	set_fixed_process(true)

func _fixed_process(delta):

	if blinking:
		
#		print(blinkTimer, " ", blinkTimer % (blinkDuration / blinkSteps), " " , blinkDuration / blinkSteps / 2)
		
		if blinkTimer % (blinkDuration / blinkSteps) > blinkDuration / blinkSteps / 2:
			set_hidden(false)
		else:
			set_hidden(true)
			
		blinkTimer = blinkTimer - 1
		if blinkTimer <= 0:
			blinking = false
			blinkTimer = blinkDuration
			set_hidden(false)
			
	if exploding:
		
		global_translate(dir)
		global_rotate(rotAxis, rotSpeed)

func explode():

	explodeTimer = explodeDuration
	exploding = true

func blink(nb):
	
	blinkDuration = blinkSpeed * nb
	blinkTimer = blinkDuration
	blinkSteps = nb
	blinking = true