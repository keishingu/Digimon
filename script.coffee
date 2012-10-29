# HTML内のcanvas要素を取得し、描画対象にする
canvas = document.getElementById 'sample'
ctx = canvas.getContext '2d'

# ドットを描く初期位置
baseX = 0
baseY = 0

class Digitama
	constructor: ->
		# 待機状態のドットを２次元配列で宣言し、数フレーム用意する
		@name = "digitama"
		@waitingDots = [
				[
					[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
					[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
					[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
					[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
					[0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0],
					[0,0,0,0,0,1,1,0,1,0,1,0,0,0,0,0],
					[0,0,0,0,1,0,1,0,1,1,0,1,0,0,0,0],
					[0,0,0,1,0,1,1,0,0,1,0,0,1,0,0,0],
					[0,0,0,1,0,1,0,0,0,1,1,0,1,0,0,0],
					[0,0,1,0,0,1,0,0,1,1,1,0,0,1,0,0],
					[0,0,1,0,1,1,0,0,1,0,1,1,0,1,0,0],
					[0,0,1,0,1,0,0,0,1,0,0,1,0,1,0,0],
					[0,0,1,0,1,0,0,0,1,0,0,1,0,1,0,0],
					[0,0,0,1,1,0,0,1,0,0,1,1,1,0,0,0],
					[0,0,0,0,1,1,1,1,0,0,1,1,0,0,0,0],
					[0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0]
				],
				[
					[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
					[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
					[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
					[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
					[0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0],
					[0,0,0,0,0,0,1,1,0,1,0,1,0,0,0,0],
					[0,0,0,0,0,1,0,1,0,1,1,0,1,0,0,0],
					[0,0,0,0,1,0,1,1,0,0,1,0,0,1,0,0],
					[0,0,0,0,1,0,1,0,0,0,1,1,0,1,0,0],
					[0,0,0,1,0,0,1,0,0,1,1,1,0,0,1,0],
					[0,0,0,1,0,1,1,0,0,1,0,1,1,0,1,0],
					[0,0,0,1,0,1,0,0,0,1,0,0,1,0,1,0],
					[0,0,0,1,0,1,0,0,0,1,0,0,1,0,1,0],
					[0,0,0,0,1,1,0,0,1,0,0,1,1,1,0,0],
					[0,0,0,0,0,1,1,1,1,0,0,1,1,0,0,0],
					[0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0]
				]
			] 
		###
		@drawing = (dots) ->
			ctx.clearRect baseX, baseY, 175, 175
			x = baseX
			y = baseY
			i = 0
			while i < 16
				j = 0
				while j < 16
					ctx.fillRect x, y, 10, 10  if dots[i][j] is 1
					x += 11
					j++
				x = baseX
				y += 11
				i++    
		###
	# 空腹度、体力の初期値
	hungry = 4
	vitality = 4
	###
	wait: -> 
		console.log "#{@name} moving!"
	eat: ->
		hungry -= 1
		console.log "#{hungry}"
	ドットをcanvas要素に描く
	###
	drawing = (dots) ->
		ctx.clearRect baseX, baseY, 175, 175
		x = baseX
		y = baseY
		i = 0
		while i < 16
			j = 0
			while j < 16
				ctx.fillRect x, y, 10, 10  if dots[i][j] is 1
				x += 11
				j++
			x = baseX
			y += 11
			i++    
	wait: ->
		frame = 1
		console.log @waitingDots
		#console.log @name
		#drawing @waitingDots[1]
		###
		setInterval (->
			frame++
		), 1000
		###
		setInterval do (@waitingDots) ->
			-> drawing @waitingDots[frame%2]; frame++
		, 1000

class Zurumon extends Digitama
	constructor: ->
		@name = "zurumon"

# モンスターを作る
monster = new Digitama
monster.wait()

###
# 1秒ごとに待機状態を入れ替える
frame = 1
setInterval (->
		console.log monster.waitingDots[frame%2]
		monster.drawing monster.waitingDots[frame%2]
		frame++
), 1000
###