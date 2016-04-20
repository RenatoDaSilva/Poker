unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Objetos, ExtCtrls;

type
  TForm6 = class(TForm)
    btDarCartas: TButton;
    lbJogador1: TLabel;
    lbCartas1: TLabel;
    lbCartas2: TLabel;
    lbJogador2: TLabel;
    LbResultadoJogador1: TLabel;
    LbResultadoJogador2: TLabel;
    lbVencedor: TLabel;
    lbResultado: TLabel;
    pnResultado: TPanel;
    pnCentral: TPanel;
    PnJogador2: TPanel;
    PnJogador1: TPanel;
    procedure btDarCartasClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;
  Jogador1, Jogador2: TJogador;

implementation

{$R *.dfm}

procedure TForm6.btDarCartasClick(Sender: TObject);
begin
  Jogador1 := TJogador.Create;
  Jogador2 := TJogador.Create;

  lbCartas1.Caption := Jogador1.CartasMao;
  lbCartas2.Caption := Jogador2.CartasMao;

  Jogador1.BuscarMelhorResultado;
  Jogador2.BuscarMelhorResultado;

  LbResultadoJogador1.Caption := Jogador1.ResultadoNome;
  LbResultadoJogador2.Caption := Jogador2.ResultadoNome;

  if Jogador1.MelhorResultado = Jogador2.MelhorResultado then
    lbResultado.Caption := 'Empate'
  else if Jogador1.MelhorResultado > Jogador2.MelhorResultado then
    lbResultado.Caption := Format('Jogador 1 vence com %s',
      [Jogador1.ResultadoNome])
  else
    lbResultado.Caption := Format('Jogador 2 vence com %s',
      [Jogador2.ResultadoNome]);

  if (Jogador1.MelhorResultado = rCartaAlta) and
    (Jogador2.MelhorResultado = rCartaAlta) then
    case Jogador1.CartaAlta.CompararCom(Jogador2.CartaAlta) of
      - 1:
        lbResultado.Caption := Format('Jogador 2 vence com %s %s',
          [Jogador2.ResultadoNome, Jogador2.CartaAlta.Carta]);
      1:
        lbResultado.Caption := Format('Jogador 1 vence com %s %s',
          [Jogador1.ResultadoNome, Jogador1.CartaAlta.Carta]);
    else
      lbResultado.Caption := 'Empate';
    end;

  btDarCartas.SetFocus;

  Jogador1.Free;
  Jogador2.Free;
end;

end.
