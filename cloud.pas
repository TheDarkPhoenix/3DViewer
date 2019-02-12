program cloud;
uses wincrt, graph, math, sysutils;
const N = 70000;
type
        p3d = record
                x,y,z:float;
        end;
        p2d = record
                x,y:float;
        end;
        p2i = record
                x,y:longint;
        end;
        kamera = record
                co, an, e:p3d;
                odl : longint;
        end;
        rgb = record
                r,g,b:integer;
        end;
var
        sterownik, tryb, i, j:integer;
        key:char;
        punkty:array[0..N] of p3d;
        kolory:array[0..N] of rgb;
        ilosc:longint;
        cam:kamera;
        b: p2d;
        kat: p3d;
        st,przes:p2i;
        pos,step,stepan:p3d;
        chmura:Text;
        il:longint;

function camaktan(kam:kamera; katy:p3d):kamera;
begin
        {if (trunc(katy.x) mod 180) <> 0 then
        begin}
                kam.an.x := katy.x;
                {kam.e.x := sin(katy.x*0.01745) * kam.odl;
                kam.e.z := cos(katy.x*0.01745) * kam.odl;}
        {end;
        if (trunc(katy.y) mod 180) <> 0 then
        begin}
                kam.an.y := katy.y;
                {kam.e.y := sin(katy.y*0.01745) * kam.odl;
                kam.e.z := cos(katy.y*0.01745) * kam.odl;}
        {end;
        if (trunc(katy.z) mod 180) <> 0 then
        begin}
                kam.an.z := katy.z;
                {kam.e.y := sin(katy.z*0.01745) * kam.odl;
                kam.e.x := cos(katy.z*0.01745) * kam.odl;}
        {end;}
        camaktan := kam;
end;

function camaktco(kam:kamera; pos:p3d):kamera;
begin
        kam.co.x := kam.co.x + pos.x;
        kam.co.y := kam.co.y + pos.y;
        kam.co.z := kam.co.z + pos.z;

        {kam.e.x := kam.e.x + pos.x;
        kam.e.y := kam.e.y + pos.y;
        kam.e.z := kam.e.z + pos.z;}

        camaktco := kam;
end;

function aktu(p:p3d; cam:kamera):p2d;
var
        x,y,z:float;
        c,s,d:p3d;
        b: p2d;
begin
        x := p.x - cam.co.x;
        y := p.y - cam.co.y;
        z := p.z - cam.co.z;

        c.x := cos(cam.an.x*0.01745);
        c.y := cos(cam.an.y*0.01745);
        c.z := cos(cam.an.z*0.01745);

        s.x := sin(cam.an.x*0.01745);
        s.y := sin(cam.an.y*0.01745);
        s.z := sin(cam.an.z*0.01745);

        d.x := c.y * (s.z * y + c.z * x) - s.y * z;
        d.y := s.x * (c.y * z + s.y * (s.z * y + c.z * x)) + c.x * (c.z * y - s.z * x);
        d.z := c.x * (c.y * z + s.y * (s.z * y + c.z * x)) - s.x * (c.z * y - s.z * x);

        if d.z <> 0 then
        begin
                b.x := (cam.e.z / d.z) * d.x - cam.e.x;
                b.y := (cam.e.z / d.z) * d.y - cam.e.y;
        end
        else
        begin
                b.x := (cam.e.z ) * d.x - cam.e.x;
                b.y := (cam.e.z) * d.y - cam.e.y;
        end;
        aktu := b;
end;

procedure draw(punkt:p2d; kolor:rgb);
var
        i:integer;
begin
        setrgbpalette(1, kolor.r, kolor.g, kolor.b);
        if ((trunc(punkt.x) > 0) and (trunc(punkt.x)<getmaxx())and (trunc(punkt.y)>0) and(trunc(punkt.y)< getmaxy()))then
                putpixel(trunc(punkt.x), trunc(punkt.y), 1);
end;

begin
        cam.co.z := -100;
        cam.an.x := 10;
        cam.an.y := 0;
        cam.an.z := 0;
        cam.e.x := 0;
        cam.e.y := 0;
        cam.odl := 1250;
        cam.e.z := cam.odl;

        stepan.x := 1;
        stepan.y := 1;
        stepan.z := 1;

        step.x := 15;
        step.y := 15;
        step.z := 15;

        sterownik := Detect;
        tryb := Detect;
        initgraph(sterownik,tryb, '');
        cam.co.x := getmaxx()/2;
        cam.co.y := getmaxy()/2;
        {cam.co.x := 0;
        cam.co.y := 0;}
        przes.x := 1*(getmaxx() div 2);
        przes.y := 1*(getmaxy() div 2);

        st.x := 500;
        st.y := 150;
        assign(chmura, 'clouda.txt');
        reset(chmura);
        read(chmura, ilosc);
        writeln(ilosc);
        if ilosc < N then
        begin
                for il := 0 to (ilosc-1) do
                begin
                        read(chmura, punkty[il].x);
                        read(chmura, punkty[il].y);
                        read(chmura, punkty[il].z);
                        read(chmura, kolory[il].r);
                        read(chmura, kolory[il].g);
                        readln(chmura, kolory[il].b);
                        punkty[i].x := punkty[il].x*10;
                        punkty[i].y := punkty[il].y*10;
                end;
        end;
        close(chmura);
        {readln;
        b := aktu(punkty[i], cam);
        cam.co.x := b.x;
        cam.co.y := b.y;}
        while key <> 'j' do
        begin
                cleardevice;
                setcolor(15);
                outtextxy(3,6,'Katy');
                outtextxy(3,16,'x: ');
                outtextxy(20,16, floattostr(cam.an.x));
                outtextxy(3,26,'y: ');
                outtextxy(20,26, floattostr(cam.an.y));
                outtextxy(3,36,'z: ');
                outtextxy(20,36, floattostr(cam.an.z));
                outtextxy(3,46,'Pozycja');
                outtextxy(3,56,'x: ');
                outtextxy(20,56, floattostr(cam.co.x));
                outtextxy(3,66,'y: ');
                outtextxy(20,66, floattostr(cam.co.y));
                outtextxy(3,76,'z: ');
                outtextxy(20,76, floattostr(cam.co.z));
                for il := 0 to (ilosc) do
                begin
                        b := aktu(punkty[il], cam);
                        b.x := b.x + przes.x;
                        b.y := b.y + przes.y;
                        draw(b, kolory[il]);
                end;
                repeat until keypressed;
                key := readkey;
                kat.x := 0;
                kat.y := 0;
                kat.z := 0;
                pos := kat;
                kat := cam.an;
                case key of
                        'z':
                        begin
                                kat.x := cam.an.x + stepan.x;
                        end;
                        'x':
                        begin
                                kat.x := cam.an.x - stepan.x;
                        end;
                        'c':
                        begin
                                kat.y := cam.an.y + stepan.y;
                        end;
                        'v':
                        begin
                                kat.y := cam.an.y - stepan.y;
                        end;
                        'b':
                        begin
                                kat.z := cam.an.z + stepan.z;
                        end;
                        'n':
                        begin
                                kat.z := cam.an.z - stepan.z;
                        end;
                        'd':
                        begin
                                pos.x := pos.x + step.x;
                        end;
                        'a':
                        begin
                                pos.x := pos.x - step.x;
                        end;
                        'w':
                        begin
                                pos.y := pos.y + step.y;
                        end;
                        's':
                        begin
                                pos.y := pos.y - step.y;
                        end;
                        'q':
                        begin
                                pos.z := pos.z + step.z;
                        end;
                        'e':
                        begin
                                pos.z := pos.z - step.z;
                        end;
                end;
                cam := camaktan(cam, kat);
                cam := camaktco(cam, pos);
        end;
        writeln(key);
        closegraph;
        readln;
end.
