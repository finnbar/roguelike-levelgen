t={} --set up as 50x50 in love.load()
oldT={} --same as t, but one step back
revive=3
c=1 --count
p=1 --processes
w=1024/8
h=768/8
total=1000 --how many do you want to be saved?
pros={}

function love.load(arg)
	for x=1,w,1 do
		table.insert(t,{})
		table.insert(oldT,{})
		for y=1,h,1 do
			table.insert(t[x],0)
			table.insert(oldT[x],0)
		end
	end
	t[25][25]=3 --2==on,can generate new pixels, 1==on,inactive, 0==off,3==on,can generate new pixels! newest process.
end

function love.draw()
	for x=1,w,1 do
		for y=1,h,1 do
			if t[x][y]>0 then
				if t[x][y]==3 then
					love.graphics.setColor(0,255,0)
				elseif t[x][y]==2 then
					love.graphics.setColor(255,0,0)
				elseif t[x][y]==1 then
					love.graphics.setColor(0,0,255)
				elseif t[x][y]==4 then
					love.graphics.setColor(255,255,0)
				elseif t[x][y]==5 then
					love.graphics.setColor(0,255,255)
				elseif t[x][y]==6 then
					love.graphics.setColor(255,0,255)
				elseif t[x][y]==7 then
					love.graphics.setColor(255,255,255)
				else
					love.graphics.setColor(130,130,130)
				end
				love.graphics.rectangle("fill",(x-1)*8,(y-1)*8,8,8)
			end
		end
	end
	love.graphics.setColor(255,255,255)
	love.graphics.print(c,0,0)
end

function love.update()
	for x=1,w,1 do
		for y=1,h,1 do
			oldT[x][y]=t[x][y]
			if t[x][y]>1 and t[x][y]<4 then
				local r = math.random(1,4)
				local q=1 --should be 1!
				if c>total then q=4 end
				if c>total*2 then q=5 end
				if c>total*3 then q=6 end
				if c>total*4 then q=7 end
				if c>total*5 then q=8 end
				if c>total*6 then break end
				if r==1 then
					if y<h then
						if t[x][y+1]>0 then
							t[x][y]=q
							p=p-1
						else 
							t[x][y+1]=3
							c=c+1
							p=p+1
						end
					else
						t[x][y]=q
						p=p-1
					end
				elseif r==2 then
					if y>1 then
						if t[x][y-1]>0 then
							t[x][y]=q
							p=p-1
						else 
							t[x][y-1]=3
							c=c+1
							p=p+1
						end
					else
						t[x][y]=q
						p=p-1
					end
				elseif r==3 then
					if x<w then
						if t[x+1][y]>0 then
							t[x][y]=q
							p=p-1
						else 
							t[x+1][y]=3
							c=c+1
							p=p+1
						end
					else
						t[x][y]=q
						p=p-1
					end
				else
					if x>1 then
						if t[x-1][y]>0 then
							t[x][y]=q
							p=p-1
						else 
							t[x-1][y]=3
							c=c+1
							p=p+1
						end
					else
						t[x][y]=q
						p=p-1
					end
				end
			end
			if t[x][y]==3 then t[x][y]=2 end
		end
	end
	--loop until c is whatever it needs to be
	if p<1 then
		if revive>0 then
			for x=1,50,1 do
				for y=1,50,1 do
					if oldT[x][y]==3 then
						t[x][y]=3
						p=p+1
					end
				end
			end
			revive=revive-1
		else
			t[math.random(1,w)][math.random(1,h)]=3
			revive=3 --it's got itself in a loop (it can only revive impossible processes)
		end
	else
		revive=3
	end
end