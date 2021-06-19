unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ComCtrls, Buttons, DateUtils, math;

type

  { TForm1 }

  TForm1 = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    btnGenerate: TButton;
    cbxRevealOne: TCheckBox;
    cbxChangeIfChance: TCheckBox;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lblTimes: TLabel;
    memCombinations: TMemo;
    memDataLog: TMemo;
    SpeedButton1: TSpeedButton;
    tkbTimes: TTrackBar;
    procedure btnGenerateClick(Sender: TObject);
    procedure cbxRevealOneChange(Sender: TObject);
    procedure cbxChangeIfChanceChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure memCombinationsChange(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure tkbTimesChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 

  bg_RevelarUma : boolean;
  bg_TrocarQuandoChance : boolean;
  ig_TotalJogados, ig_TotalPontos : integer;

implementation

uses unit2;
{$R *.lfm}

{ TForm1 }

procedure TForm1.btnGenerateClick(Sender: TObject);
var
   al_portas : array [1..3] of integer;
   al_contaPortas : array [1..3] of integer;
   al_contaAcertos : Array [1..3] of integer;
   il_contador : integer;
   il_NovaPorta, il_contaAcerto : integer;
   il_revelado, il_posicaoRevelada, il_posicaoAcerto : integer;
   bl_jaTrocou : boolean;
begin
    // zera contadores
    al_contaPortas[1] := 0;
    al_contaPortas[2] := 0;
    al_contaPortas[3] := 0;

    al_contaAcertos[1] := 0;
    al_contaAcertos[2] := 0;
    al_contaAcertos[3] := 0;

    il_contaAcerto:=0;

    for il_contador := 1 to (tkbTimes.Position*10) do
     begin
          // bode nas portas
          al_portas[1] := 0;
          al_portas[2] := 0;
          al_portas[3] := 0;

          //carro em uma das portas
          al_portas[random(3)+1] := 1;

          // atualiza contador de porta
          if al_portas[1] = 1 then
           al_contaPortas[1] := al_contaPortas[1] + 1
          else if al_portas[2] = 1 then
           al_contaPortas[2] := al_contaPortas[2] + 1
          else
          al_contaPortas[3] := al_contaPortas[3] + 1;

          //convidado seleciona porta
          il_posicaoAcerto := random(3)+1;
//          il_posicaoAcerto := 3; // fixa porta selecionada
          memCombinations.Lines.Add('Guest selected door:'+IntToStr(il_posicaoAcerto));

          //se pediu pra revelar, entao revela e salva porta revelada
          if bg_RevelarUma = true then
           begin;
                il_revelado := 0;

                 while il_revelado = 0 do
                 begin
                      il_posicaoRevelada := random(3)+1;

                      if (al_portas[il_posicaoRevelada] = 0) and (il_posicaoRevelada <> il_posicaoAcerto) then
                       begin
                          il_revelado := il_posicaoRevelada;
                          memCombinations.Lines.Add('The host revealed the door:'+IntToStr(il_revelado));
                       end;
                 end;
           end;

          // se pediu pra trocar quando houver chance, entao troca
          if bg_TrocarQuandoChance = true then
           begin
                bl_jaTrocou := false;

                for il_NovaPorta := 1 to 3 do
                 begin
                      if (il_NovaPorta <> il_posicaoRevelada) and (il_NovaPorta <> il_posicaoAcerto) and (bl_jatrocou=False) then
                       begin
                            il_posicaoAcerto:=il_NovaPorta;
                            bl_jaTrocou := true;
                       end;
                 end;

                memCombinations.Lines.Add('Guest changed the door to:'+IntToStr(il_posicaoAcerto));

           end
          else
           memCombinations.Lines.Add('Guest stayed on door:'+IntToStr(il_posicaoAcerto));


          // contabiliza acerto
          if al_portas[il_posicaoAcerto] = 1 then
           begin
                il_contaAcerto:=il_contaAcerto+1;
                al_contaAcertos[il_posicaoAcerto] := al_contaAcertos[il_posicaoAcerto]+1;
                memCombinations.Lines.Add('Guest win staying with door:'+IntToStr(il_posicaoAcerto));
           end
          else
           memCombinations.Lines.Add('Guest failed staying with door:'+IntToStr(il_posicaoAcerto));

          memCombinations.Lines.Add('Doors: ['+IntToStr(al_portas[1])+'-'+IntToStr(al_portas[2])+'-'+IntToStr(al_portas[3])+']');
     end;

    memCombinations.Lines.Add('-------');

    // adiciona dados
    memDataLog.Lines.Add('['+FormatDateTime('dd/mm/yyyy - hh:mm:ss', Now())+']-----------------------------------------------------');

    memDataLog.Lines.Add('Door 1 was awarded '+IntToStr(al_contaPortas[1])+' times');
    memDataLog.Lines.Add('Door 2 was awarded '+IntToStr(al_contaPortas[2])+' times');
    memDataLog.Lines.Add('Door 3 was awarded '+IntToStr(al_contaPortas[3])+' times');
    memDataLog.Lines.Add(' ');

    memDataLog.Lines.Add('The guest guessed '+IntToStr(il_contaAcerto)+' times');
    memDataLog.Lines.Add('where: '+IntToStr(al_contaAcertos[1])+' on door 1, '+IntToStr(al_contaAcertos[2])+' on door 2, '+IntToStr(al_contaAcertos[3])+' on door 3');
    memDataLog.Lines.Add(' ');

    // atualiza pontos
    ig_TotalJogados := ig_TotalJogados + tkbTimes.Position;
    ig_TotalPontos := ig_TotalPontos + il_contaAcerto;

    memDataLog.Lines.Add('Hit average: '+FloatToStr(RoundTo(ig_TotalPontos/ig_TotalJogados,-2)) );
    memDataLog.Lines.Add(' ');
end;

procedure TForm1.cbxRevealOneChange(Sender: TObject);
begin
  if cbxRevealOne.Checked = true then
   bg_RevelarUma := true
  else
   bg_RevelarUma := false;
end;

procedure TForm1.cbxChangeIfChanceChange(Sender: TObject);
begin
  if cbxChangeIfChance.Checked = true then
   bg_TrocarQuandoChance := true
  else
   bg_TrocarQuandoChance := false;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.FormShow(Sender: TObject);
begin
    Randomize;

    memDataLog.Clear;
    memCombinations.Clear;

    bg_RevelarUma := false;
    bg_TrocarQuandoChance := false;

    ig_TotalJogados := 0;
    ig_TotalPontos := 0;

    Form2.Showmodal;
end;

procedure TForm1.Label1Click(Sender: TObject);
begin

end;

procedure TForm1.Label3Click(Sender: TObject);
begin

end;

procedure TForm1.memCombinationsChange(Sender: TObject);
begin

end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  memCombinations.Clear;
  memDataLog.Clear;

  ig_TotalPontos := 0;
  ig_TotalJogados := 0;
end;

procedure TForm1.tkbTimesChange(Sender: TObject);
begin
  lblTimes.Caption:=IntToStr(tkbTimes.Position*10);
end;

end.

