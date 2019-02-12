program domeczek;
uses wincrt, graph, math, sysutils;
const N = 20;
type
        p3d = record
                x,y,z:float;
        end;
        p2d = record
                x,y:float;
        end;
        p2i = record
                x,y:integer;
        end;
        kamera = record
                co, an, e:p3d;
                odl : integer;
        end;
        sc4 = record
                a,b,c,d:integer;
                srodek:p3d;
                odl:float;
                kw:array[0..3] of PointType;
                il,sty:integer;
        end;
var
        sterownik, tryb, i, j:integer;
        key:char;
        punkty:array[0..N] of p3d;
        nowe:array[0..N] of p2i;
        cam:kamera;
        b: p2d;
        kat: p3d;
        st,przes:p2i;
        pos,step,stepan:p3d;
        domek:array[0..11] of sc4;
        buf:sc4;

function camaktan(kam:kamera; katy:p3d):kamera;
begin
        kam.an.x := katy.x;
        kam.an.y := katy.y;
        kam.an.z := katy.z;
        camaktan := kam;
end;

function camaktco(kam:kamera; pos:p3d):kamera;
begin
        kam.co.x := kam.co.x + pos.x;
        kam.co.y := kam.co.y + pos.y;
        kam.co.z := kam.co.z + pos.z;

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

procedure initdomek();
begin
        punkty[0].x := 100+st.x;
        punkty[0].y := 100+st.y;
        punkty[0].z := 100;

        punkty[1].x := 100+st.x;
        punkty[1].y := 200+st.y;
        punkty[1].z := 100;

        punkty[2].x := 300+st.x;
        punkty[2].y := 200+st.y;
        punkty[2].z := 100;

        punkty[3].x := 300+st.x;
        punkty[3].y := 100+st.y;
        punkty[3].z := 100;

        punkty[4].x := 100+st.x;
        punkty[4].y := 100+st.y;
        punkty[4].z := 200;

        punkty[5].x := 100+st.x;
        punkty[5].y := 200+st.y;
        punkty[5].z := 200;

        punkty[6].x := 300+st.x;
        punkty[6].y := 200+st.y;
        punkty[6].z := 200;

        punkty[7].x := 300+st.x;
        punkty[7].y := 100+st.y;
        punkty[7].z := 200;

        punkty[8].x := 185+st.x;
        punkty[8].y := 150+st.y;
        punkty[8].z := 100;

        punkty[9].x := 215+st.x;
        punkty[9].y := 150+st.y;
        punkty[9].z := 100;

        punkty[10].x := 215+st.x;
        punkty[10].y := 200+st.y;
        punkty[10].z := 100;

        punkty[11].x := 185+st.x;
        punkty[11].y := 200+st.y;
        punkty[11].z := 100;

        punkty[12].x := 125+st.x;
        punkty[12].y := 125+st.y;
        punkty[12].z := 100;

        punkty[13].x := 150+st.x;
        punkty[13].y := 125+st.y;
        punkty[13].z := 100;

        punkty[14].x := 150+st.x;
        punkty[14].y := 150+st.y;
        punkty[14].z := 100;

        punkty[15].x := 125+st.x;
        punkty[15].y := 150+st.y;
        punkty[15].z := 100;

        punkty[16].x := 275+st.x;
        punkty[16].y := 125+st.y;
        punkty[16].z := 100;

        punkty[17].x := 275+st.x;
        punkty[17].y := 150+st.y;
        punkty[17].z := 100;

        punkty[18].x := 250+st.x;
        punkty[18].y := 150+st.y;
        punkty[18].z := 100;

        punkty[19].x := 250+st.x;
        punkty[19].y := 125+st.y;
        punkty[19].z := 100;

        punkty[20].x := 200+st.x;
        punkty[20].y := 50+st.y;
        punkty[20].z := 150;

        domek[0].a := 0;
        domek[0].b := 1;
        domek[0].c := 2;
        domek[0].d := 3;

        domek[1].a := 0;
        domek[1].b := 1;
        domek[1].c := 5;
        domek[1].d := 4;

        domek[2].a := 3;
        domek[2].b := 2;
        domek[2].c := 6;
        domek[2].d := 7;

        domek[3].a := 4;
        domek[3].b := 5;
        domek[3].c := 6;
        domek[3].d := 7;

        domek[4].a := 1;
        domek[4].b := 2;
        domek[4].c := 6;
        domek[4].d := 5;

        domek[5].a := 8;
        domek[5].b := 11;
        domek[5].c := 10;
        domek[5].d := 9;

        domek[6].a := 12;
        domek[6].b := 15;
        domek[6].c := 14;
        domek[6].d := 13;

        domek[7].a := 19;
        domek[7].b := 18;
        domek[7].c := 17;
        domek[7].d := 16;

        for i := 0 to 7 do
        begin
                domek[i].srodek.x := (punkty[domek[i].a].x + punkty[domek[i].d].x)/ 2;
                domek[i].srodek.y := (punkty[domek[i].a].y + punkty[domek[i].b].y)/ 2;
                domek[i].srodek.z := punkty[domek[i].a].z;
                domek[i].sty := 5;
        end;

        domek[5].sty := 7;
        domek[6].sty := 9;
        domek[7].sty := 9;
        domek[4].srodek.z := (punkty[domek[4].a].z + punkty[domek[4].d].z)/ 2;

        domek[5].srodek := domek[0].srodek;
        domek[6].srodek := domek[0].srodek;
        domek[7].srodek := domek[0].srodek;

        domek[8].a := 0;
        domek[8].b := 3;
        domek[8].c := 20;
        domek[8].d := -1;

        domek[9].a := 3;
        domek[9].b := 7;
        domek[9].c := 20;
        domek[9].d := -1;

        domek[10].a := 7;
        domek[10].b := 4;
        domek[10].c := 20;
        domek[10].d := -1;

        domek[11].a := 0;
        domek[11].b := 4;
        domek[11].c := 20;
        domek[11].d := -1;

        for i := 8 to 11 do
        begin
                domek[i].srodek.x := (punkty[domek[i].a].x + punkty[domek[i].b].x) / 2;
                domek[i].srodek.y := (punkty[domek[i].a].y + punkty[domek[i].b].y) /2;
                domek[i].srodek.z := punkty[domek[i].a].z;
                domek[i].sty := 10;
        end;

        domek[9].srodek.z := (punkty[domek[i].a].z + punkty[domek[i].b].z) / 2;

        domek[11].srodek.z := (punkty[domek[i].a].z + punkty[domek[i].b].z) / 2;
        buf := domek[4];
        domek[4] := domek[11];
        domek[11] := buf;
end;

procedure drawdomek(punkty:array of p2i;kam:kamera);
var
        p:p3d;
        i,inde, py,j:integer;
        low:float;
        domeksort:array[0..11] of sc4;
        buf:sc4;
begin
        for i := 0 to 11 do
        begin
                p.x :=  (domek[i].srodek.x-kam.co.x);
                p.y := (domek[i].srodek.y-kam.co.y);
                p.z := (domek[i].srodek.z-kam.co.z);

                domek[i].odl := sqrt(p.x*p.x + p.y*p.y + p.z*p.z);

                domek[i].il := 4;
                domek[i].kw[0].x := punkty[domek[i].a].x;
                domek[i].kw[0].y := punkty[domek[i].a].y;

                domek[i].kw[1].x := punkty[domek[i].b].x;
                domek[i].kw[1].y := punkty[domek[i].b].y;

                domek[i].kw[2].x := punkty[domek[i].c].x;
                domek[i].kw[2].y := punkty[domek[i].c].y;

                if domek[i].d >= 0 then
                begin
                        domek[i].kw[3].x := punkty[domek[i].d].x;
                        domek[i].kw[3].y := punkty[domek[i].d].y;
                end
                else
                        domek[i].il := 3;

                domeksort[i] := domek[i];
        end;

        for i := 0 to 9 do
        begin
                py := 0;
                for j := 0 to 9 do
                begin
                        if domeksort[j].odl < domeksort[j+1].odl then
                        begin
                                buf := domeksort[j];
                                domeksort[j] := domeksort[j+1];
                                domeksort[j+1] := buf;
                                py := 1;
                        end;
                end;
                if py = 0 then
                        break;
        end;
        setfillstyle(1,domek[11].sty);
        fillpoly(domeksort[i].il, domek[11].kw);
        for i := 0 to 10 do
        begin
                setfillstyle(1,domeksort[i].sty);
                fillpoly(domeksort[i].il, domeksort[i].kw);
        end;
end;

procedure draw(punkty:array of p2i);
var
        i:integer;
begin
        for i := 0 to 3 do
        begin
                line(punkty[i].x, punkty[i].y, punkty[(i+1) mod 4].x, punkty[(i+1) mod 4].y);
        end;
        for i := 4 to 6 do
        begin
                line(punkty[i].x, punkty[i].y, punkty[(i+1)].x, punkty[(i+1)].y);
        end;
        line(punkty[7].x, punkty[7].y, punkty[4].x, punkty[4].y);
        for i := 0 to 3 do
                line(punkty[i].x, punkty[i].y, punkty[i+4].x, punkty[i+4].y);
        for i := 0 to 2 do
        begin
                line(punkty[i+8].x, punkty[i+8].y, punkty[i+9].x, punkty[i+9].y);
        end;
        line(punkty[8].x, punkty[8].y, punkty[11].x, punkty[11].y);
        for i := 0 to 2 do
        begin
                line(punkty[i+12].x, punkty[i+12].y, punkty[i+13].x, punkty[i+13].y);
        end;
        line(punkty[12].x, punkty[12].y, punkty[15].x, punkty[15].y);
        for i := 0 to 2 do
        begin
                line(punkty[i+16].x, punkty[i+16].y, punkty[i+17].x, punkty[i+17].y);
        end;
        line(punkty[16].x, punkty[16].y, punkty[19].x, punkty[19].y);
        line(punkty[20].x, punkty[20].y, punkty[0].x, punkty[0].y);
        line(punkty[20].x, punkty[20].y, punkty[3].x, punkty[3].y);
        line(punkty[20].x, punkty[20].y, punkty[4].x, punkty[4].y);
        line(punkty[20].x, punkty[20].y, punkty[7].x, punkty[7].y);
end;

begin
        cam.co.z := -300;
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

        step.x := 5;
        step.y := 5;
        step.z := 5;

        sterownik := Detect;
        tryb := Detect;
        initgraph(sterownik,tryb, '');
        cam.co.x := getmaxx()/2;
        cam.co.y := getmaxy()/2;
        {cam.co.x := 0;
        cam.co.y := 0;}
        przes.x := getmaxx() div 2;
        przes.y := getmaxy() div 2;

        st.x := 500;
        st.y := 150;

        initdomek();

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
                for i := 0 to N do
                begin
                        b := aktu(punkty[i], cam);
                        nowe[i].x := trunc(b.x) + przes.x;
                        nowe[i].y := trunc(b.y) + przes.y;
                end;
                drawdomek(nowe,cam);
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
