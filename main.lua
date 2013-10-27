t={} --set up in love.load()
revive=3
c=0 --count
p=0 --processes
s=4 --current benchmark: completed in 9(was 70!) seconds with these settings
w=math.floor(1024/s)
h=math.floor(768/s)
total=9000*(4/s) --how many do you want to be saved?
procs={} --this makes the program REALLY FAST, which is wonderful
nProcs={} --newest procs
finished = false
q=1
time=0
reps=14 --for startUp()s
player={}
playerPrev={}
blocksPrev={1,1}
pLeft,pRight=false,false
jump = true

function love.load()
	for x=1,w,1 do
		table.insert(t,{})
		for y=1,h,1 do
			table.insert(t[x],0)
		end
	end
	for i=1,reps,1 do
		local un = math.floor(h/2)
		local deux = math.floor(w/2)
		startUp(un,deux)
		startUp(w-un,h-deux)
	end
end

function love.draw()
	if playerPrev[1]~=nil then
		if player[1]~=playerPrev[1] or player[2]~=playerPrev[2] then
			t[playerPrev[1]][playerPrev[2]]=blocksPrev[1]
			t[playerPrev[1]][playerPrev[2]-1]=blocksPrev[2]
			blocksPrev[1]=t[player[1]][player[2]]
			blocksPrev[2]=t[player[1]][player[2]-1]
			t[player[1]][player[2]]=8
			t[player[1]][player[2]-1]=8
		end
	end
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
				elseif t[x][y]==8 then
					love.graphics.setColor(255,255,255) --player
				end
				love.graphics.rectangle("fill",(x-1)*s,(y-1)*s,s,s)
			end
		end
	end
	love.graphics.setColor(255,255,255)
	love.graphics.print(c,0,0)
	love.graphics.print(time,0,15)
	if player[1]~=nil then
		playerPrev[1]=player[1]
		playerPrev[2]=player[2]
	end
end

function love.update(dt)
	playerMov()
	for i in pairs(nProcs) do
		table.remove(nProcs,i)
	end
	for i in pairs(procs) do
		local x = procs[i][1]
		local y = procs[i][2]
		if t[x][y]==3 then t[x][y]=2 end
	end
	if not finished then
		time=time+dt
		for i in pairs(procs) do
			local x=procs[i][1]
			local y=procs[i][2]
			if t[x][y]>1 and t[x][y]<4 then
				local r = math.random(1,4)
				if r==1 then
					if y<h then
						if t[x][y+1]>0 then
							t[x][y]=q
							p=p-1
						else 
							t[x][y+1]=3
							table.insert(procs,{x,y+1})
							table.insert(nProcs,{x,y+1})
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
							table.insert(procs,{x,y-1})
							table.insert(nProcs,{x,y-1})
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
							table.insert(procs,{x+1,y})
							table.insert(nProcs,{x+1,y})
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
							table.insert(procs,{x-1,y})
							table.insert(nProcs,{x-1,y})
							c=c+1
							p=p+1
						end
					else
						t[x][y]=q
						p=p-1
					end
				end
			end
		end
		for i in pairs(procs) do
			if t[procs[i][1]][procs[i][2]]~=2 and t[procs[i][1]][procs[i][2]]~=3 then
				table.remove(procs,i)
			end
		end
		-- for i in pairs(procs) do
		-- 	print(procs[i][1],procs[i][2])
		-- end
		--print("STOP with "..#procs.." procs")
		--loop until c is whatever it needs to be
		if #procs==0 then
			if revive>0 then
				for i in pairs(nProcs) do
					local x = nProcs[i][1]
					local y = nProcs[i][2]
					t[x][y]=3
					p=p+1
				end
				revive=revive-1
			else
				for i=1,reps,1 do
					local un = math.random(1,w-1)
					local deux = math.random(1,h-1)
					startUp(un,deux)
					startUp(w-un,h-deux)
				end
				revive=3 --it's got itself in a loop (it can only revive impossible processes)
			end
		else
			revive=3
		end
		if c>total then
			finished=true
			completed()
		end
	else
		if t[player[1]][player[2]+1]==1 then
			player[2]=player[2]+1
			jump=false
		else jump=true end
	end
end

function completed()
	finished = true
	for x=1,w,1 do
		for y=1,h,1 do
			if t[x][y]==3 or t[x][y]==2 then t[x][y]=1 end
			count=0
			if t[x][y]==0 then
				for i=-1,1,1 do
					for j=-1,1,1 do
						if (x+i)>0 and (x+i)<w and (y+j)>0 and (y+j)<h then
							if t[x+i][y+j] ~= 0 then
								count=count+1
							end
						end
					end
				end
				if count>3 then t[x][y]=1 end
			end
		end
	end
	local placed = false
	for x=1,w,1 do
		for y=1,h,1 do
			if t[x][y]>0 then
				if t[x][y-1]==0 then
					t[x][y]=4
				end
			end
			if t[x][y]==1 and t[x][y-1]==1 and not placed then
				t[x][y]=8
				t[x][y-1]=8
				player={x,y}
				placed = true
			end
		end
	end
end

function startUp(un,deux)
	t[un][deux]=3
	t[un+1][deux]=3
	t[un][deux+1]=3
	t[un+1][deux+1]=3
	table.insert(procs,{un,deux})
	table.insert(nProcs,{un,deux})
	table.insert(procs,{un,deux+1})
	table.insert(nProcs,{un,deux+1})
	table.insert(procs,{un+1,deux})
	table.insert(nProcs,{un+1,deux})
	table.insert(procs,{un+1,deux+1})
	table.insert(nProcs,{un+1,deux+1})
	p=p+4
	c=c+4
end

function love.keypressed(key, unicode)
	if key=="left" then pLeft = true end
	if key=="right" then pRight = true end
	if key=="up" then
		if t[player[1]][player[2]-2]==1 then
			if jump then
				player[2]=player[2]-2
				jump=false
				if t[player[1]][player[2]-3]==1 then
					player[2]=player[2]-1
				end
			end
		end
	end
end

function love.keyreleased(key)
	if key=="left" then pLeft = false end
	if key=="right" then pRight = false end
end

function playerMov()
	if finished then
		if pLeft then
			if player[1]>1 then
				if t[player[1]-1][player[2]]==1 then
					player[1]=player[1]-1
				end
			end
		elseif pRight then
			if player[1]<w then
				if t[player[1]+1][player[2]]==1 then
					player[1]=player[1]+1
				end
			end
		end
	end
end