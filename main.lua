local imageFile
local imgDisparo
local target

local disparos={}
local cooldown=0

local Botones={}

local alfabeto={}
local LetraPreguntar
local aleatorio

local posicionForm

local alternativas={}

local senas = {}

puntuacion=0

enemy={}
enemies_controller={}
enemies_controller.enemies={}
enemies_controller.image=love.graphics.newImage("Cookie.png")

local cooldownSpawn=0

function newEnemy(y)
    local enemy={}
    enemy.x=40
    enemy.y=y
    enemy.width=64
    enemy.height=64
    enemy.removed=false
    enemy.hit=false
    table.insert(disparos,enemy)
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
    return x1 < x2+w2 and
           x2 < x1+w1 and
           y1 < y2+h2 and
           y2 < y1+h1
end

function DetenerTodo()
    if comboCount==5 then
        Combo=true
    end
end

function generateButton(x,y)
    singleButton={}
    singleButton.imgButton = love.graphics.newImage("blue_Button.png")
    singleButton.x=x
    singleButton.y=y
    singleButton.width=70
    singleButton.height=20
    table.insert(Botones,singleButton)
end

function llenarAlfabeto()
    alfabeto[1]="barato"
    alfabeto[2]="caliente"
    alfabeto[3]="cariñoso"
    alfabeto[4]="caro"
    alfabeto[5]="nueva"
    alfabeto[6]="vieja"
    alfabeto[7]="cuantos"
    alfabeto[8]="dificil"
    alfabeto[9]="dolor"
    alfabeto[10]="dulce"
    alfabeto[11]="enfermo"
    alfabeto[12]="facil"
    alfabeto[13]="familia"
    alfabeto[14]="frio"
    alfabeto[15]="lento"
    alfabeto[16]="mexico"
    alfabeto[17]="mirarme"
    alfabeto[18]="normal"
    alfabeto[19]="para"
    alfabeto[20]="por"
    alfabeto[21]="quien"
    alfabeto[22]="rapido"
    alfabeto[23]="raro"
    alfabeto[24]="trabajador"
    alfabeto[25]="un dia"
    alfabeto[26]="uds. dos"
    alfabeto[27]="vaga"
    alfabeto[28]="ya"
    alfabeto[29]="yo"
end

function imgSenas()
    senas[1]=love.graphics.newImage("senas/barato.png")
    senas[2]=love.graphics.newImage("senas/caliente.png")
    senas[3]=love.graphics.newImage("senas/cariñoso.png")
    senas[4]=love.graphics.newImage("senas/caro.png")
    senas[5]=love.graphics.newImage("senas/cosa nueva.png")
    senas[6]=love.graphics.newImage("senas/cosa vieja.png")
    senas[7]=love.graphics.newImage("senas/cuantos.png")
    senas[8]=love.graphics.newImage("senas/dificil.png")
    senas[9]=love.graphics.newImage("senas/dolor.png")
    senas[10]=love.graphics.newImage("senas/dulce.png")
    senas[11]=love.graphics.newImage("senas/enfermo.png")
    senas[12]=love.graphics.newImage("senas/facil.png")
    senas[13]=love.graphics.newImage("senas/familia.png")
    senas[14]=love.graphics.newImage("senas/frio.png")
    senas[15]=love.graphics.newImage("senas/lento.png")
    senas[16]=love.graphics.newImage("senas/mexico.png")
    senas[17]=love.graphics.newImage("senas/mirarme.png")
    senas[18]=love.graphics.newImage("senas/normal.png")
    senas[19]=love.graphics.newImage("senas/para.png")
    senas[20]=love.graphics.newImage("senas/por.png")
    senas[21]=love.graphics.newImage("senas/quien.png")
    senas[22]=love.graphics.newImage("senas/rapido.png")
    senas[23]=love.graphics.newImage("senas/raro.png")
    senas[24]=love.graphics.newImage("senas/trabajadora.png")
    senas[25]=love.graphics.newImage("senas/un dia.png")
    senas[26]=love.graphics.newImage("senas/ustedes dos.png")
    senas[27]=love.graphics.newImage("senas/vaga.png")
    senas[28]=love.graphics.newImage("senas/ya.png")
    senas[29]=love.graphics.newImage("senas/yo.png")
end

function escogerLetra()
    aleatorio = math.random(1,27)
    return aleatorio
end

function poAleatorio()
    return math.random(1,3)
end

function crearAlt()
    auxale=escogerLetra()
    while auxale == aleatorio do
        auxale=math.random(1,29)
    end
    alternativas[1]=auxale
    auxale=escogerLetra()
    while auxale == aleatorio or auxale ==alternativas[1] do
        auxale=math.random(1,27)
    end
    alternativas[2]=auxale
end

function prepReset()
    aleatorio = escogerLetra()
    posicionForm = poAleatorio()
    crearAlt()
end

function enemies_controller:spawnEnemy(x,y)
    enemy={}
    enemy.x = x
    enemy.y = y
    enemy.bullets = {}
    enemy.cooldown = 20
    enemy.speed = 20
    enemy.width=10
    enemy.height=10
    table.insert(self.enemies,enemy)
end

function limpiarDisparos()
    for d=#disparos,1,-1 do
        table.remove(disparos,d)
    end
end

function love.load()
    --matriz con imagenes
    imgSenas()
    --------------------------------------------------------------------------------------------------------------------
    --imagen de fondo
    image = love.graphics.newImage("spacing.png")
    position = 0
    --------------------------------------------------------------------------------------------------------------------

    imageFile = love.graphics.newImage("sprite_del_mario.png")
    posY=1
    imgDisparo = love.graphics.newImage("image.png")


    enemies_controller:spawnEnemy(600,50)
    enemies_controller:spawnEnemy(600,300)
    
    generateButton(130,500)
    generateButton(280,500)
    generateButton(440,500)

    --escoger posicion en el formulario
    posicionForm=poAleatorio()
    --llenar el alfabeto
    llenarAlfabeto()
    --escoger una letra a preguntar inicialmente
    aleatorio = escogerLetra()
    LetraPreguntar = escogerLetra()

    crearAlt()

    --canvas para el puntaje
    local myfont = love.graphics.newFont(45)
    love.graphics.setFont(myfont)
    love.graphics.setColor(255,255,255)
    love.graphics.setBackgroundColor(0,0,0)

    comboCount=0
    fuente=love.graphics.newFont(30)

    Combo=false

end

function love.update(dt)
    DetenerTodo()

    --movimiendo del fondo
    local speed = 200  --speed, higher means more speed
    if Combo==false then
        position = (position - speed*dt) % image:getWidth()

        if cooldownSpawn==0 then
            cooldownSpawn=90
            enemies_controller:spawnEnemy(800,math.random(1,600))
        else
            cooldownSpawn=cooldownSpawn-1
        end
    end
    -----------------------------------------------------------------------------------------------------------------------
    
    if cooldown > 0 then
        cooldown=cooldown-1
    end
    if (love.keyboard.isDown('down') and posY<520 and Combo==false) then
        posY=posY+10
    end
    if (love.keyboard.isDown('up') and posY>-50 and Combo==false) then
        posY=posY-10
    end
    if(love.keyboard.isDown('space') and cooldown==0 and Combo==false)then
        newEnemy(posY+50)
        cooldown=10
    end
    for j=#disparos,1,-1 do
        local enemy=disparos[j]
        if enemy.x>800 then
            table.remove(disparos,j)
        end
        if Combo==false then
            enemy.x=enemy.x + 10
        end
        
    end
    for i=#enemies_controller.enemies,1,-1 do
        local enemy = enemies_controller.enemies[i]
        if enemy.x<=100 then
            table.remove(enemies_controller.enemies,i)
            comboCount=0
            puntuacion=puntuacion-2
        end

        for z=#disparos,1,-1 do
            local shoot=disparos[z]
            ColisionDetectada=CheckCollision(shoot.x,shoot.y,shoot.width,shoot.height,enemy.x,enemy.y,enemy.x+enemy.width,enemy.y + enemy.height)
            if ColisionDetectada then
                comboCount=comboCount+1
                puntuacion=puntuacion+1
                table.remove(enemies_controller.enemies,i)
                table.remove(disparos,z)
            end
        end

        enemy.x=enemy.x-10
    end
end

function love.mousepressed(x,y,button)
    if (x>145 and x<290 and y>500 and y < 545 and Combo) then
        if posicionForm==1 then
            puntuacion=puntuacion+200
        end
        Combo=false
        comboCount=0
        prepReset()
        limpiarDisparos()
    end
    if (x>293 and x<440 and y>500 and y < 545 and Combo) then
        if posicionForm==2 then
            puntuacion=puntuacion+200
        end
        Combo=false
        comboCount=0
        prepReset()
        limpiarDisparos()
    end
    if (x>450 and x<600 and y>500 and y < 545 and Combo) then
        if posicionForm==3 then
            puntuacion=puntuacion+200
        end
        Combo=false
        comboCount=0
        prepReset()
        limpiarDisparos()
    end
    
end

function love.draw()

    love.graphics.draw(image, position, 0)  --draw first image
    love.graphics.draw(image, position - image:getWidth(), 0)  --fraw second image

    love.graphics.draw(imageFile,140,posY,0,-0.3,0.3)

    for i=#disparos,1,-1 do 
        local enemy=disparos[i]
        traslation=enemy.x + 50
        love.graphics.draw(imgDisparo,traslation,enemy.y,0,0.1,0.1)
    end

    for _,e in pairs(enemies_controller.enemies)do
        love.graphics.draw(enemies_controller.image,e.x,e.y,0,0.4)
    end

    love.graphics.setFont(fuente)
    love.graphics.print("x"..comboCount, (love.graphics.getWidth()/2)+250,0)
    love.graphics.print("score:"..puntuacion,40,10)

    if Combo then
        love.graphics.print("¿qué significa?", 250,90,0,1.5,1.5)
        love.graphics.draw(senas[aleatorio],290,150,0,1.5,1.5)

        local cont=1
        for i=#Botones,1,-1 do
            local boton=Botones[i]
            love.graphics.draw(boton.imgButton,boton.x,boton.y,0,0.17,0.1)
            if(i==posicionForm) then
                love.graphics.print(alfabeto[aleatorio],boton.x+20,boton.y+5)
            else
                value = alternativas[cont]
                love.graphics.print(alfabeto[value],boton.x+20,boton.y+5)
                cont=cont+1
            end
        end
    end
end
