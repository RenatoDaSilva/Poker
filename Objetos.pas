unit Objetos;

{
No jogo de Poker, uma m�o consiste em cinco cartas que podem ser comparadas, da mais baixa para a mais alta, da seguinte maneira:
    Carta Alta: A carta de maior valor.
    Um Par: Duas cartas do mesmo valor.
    Dois Pares: Dois pares diferentes.
    Trinca: Tr�s cartas do mesmo valor e duas de valores diferentes.
    Straight (seq��ncia): Todas as carta com valores consecutivos.
    Flush: Todas as cartas do mesmo naipe.
    Full House: Um trinca e um par.
    Quadra: Quatro cartas do mesmo valor.
    Straight Flush: Todas as cartas s�o consecutivas e do mesmo naipe.
    Royal Flush: A seq��ncia 10, Valete, Dama, Rei, �s, do mesmo naipe.
    As cartas s�o, em ordem crescente de valor: 2, 3, 4, 5, 6, 7, 8, 9, 10(T), Valete(J), Dama(Q), Rei(K), �s(A).
    Os naipes s�o: Ouro (D), Copa (H), Espadas (S), Paus (C)
}

interface

uses SysUtils, TypInfo;

type
  TValor = (c2, c3, c4, c5, c6, c7, c8, c9, cT, cJ, cQ, cK, cA);
  TNaipe = (nD, nH, nS, nC);
  TResultado = (rCartaAlta, rUmPar, rDoisPares, rTrinca, rStraight, rFlush, rFullHouse, rQuadra, rStraightFlush, rRoyalFlush);

  TCarta = class
  private
    FValor : TValor;
    FNaipe : TNaipe;
    FCarta : string;
    FPosicao:integer;
    procedure SetNaipe(const Value: TNaipe);
    procedure SetValor(const Value: TValor);
    function GetCarta: string;
    procedure SetPosicao(const Value: integer);
  public
    property Valor : TValor read FValor write SetValor;
    property Naipe : TNaipe read FNaipe write SetNaipe;
    property Carta : string read GetCarta;
    property Posicao : integer read FPosicao write SetPosicao;
    function CompararCom(aCarta:TCarta):integer;
  end;


  TJogador = class
  private
    FMelhorResultado: TResultado;
    FCartasMao: string;
    FResultadoNome:string;
    procedure SetMelhorResultado(const Value: TResultado);
    function GetMelhorResultado: TResultado;
    procedure OrdenarMao;
    function GetCartasMao: string;
    procedure SetResultadoNome(const Value: string);
    function GetResultadoNome: string;
  public
    Mao: Array[0..4] of TCarta;
    CartaAlta:TCarta;
    Par: Array[0..1] of TCarta; //Duas cartas do mesmo valor.
    DoisPares: Array[0..3] of TCarta; //Dois pares diferentes.
    Trinca: Array[0..2] of TCarta; //Tr�s cartas do mesmo valor e duas de valores diferentes.
    Straight: Array[0..4] of TCarta; //Todas as carta com valores consecutivos.
    Flush: Array[0..4] of TCarta; //Todas as cartas do mesmo naipe.
    FullHouse: Array[0..4] of TCarta; //Um trinca e um par.
    Quadra: Array[0..3] of TCarta; //Quatro cartas do mesmo valor.
    StraightFlush: Array[0..4] of TCarta; //Todas as cartas s�o consecutivas e do mesmo naipe.
    RoyalFlush: Array[0..4] of TCarta; // A seq��ncia 10, Valete, Dama, Rei, �s, do mesmo naipe.
    constructor Create;
    destructor Destroy;

    property MelhorResultado: TResultado read GetMelhorResultado write SetMelhorResultado;
    property ResultadoNome: string read GetResultadoNome write SetResultadoNome;
    property CartasMao: string read GetCartasMao;
    procedure BuscarMelhorResultado;
    procedure ValidarResultado(var Tipo: Array of TCarta);
  end;

  TBaralho = class
    public
      Carta: Array of TCarta;
      constructor Create;
      destructor Destroy;
  end;

var
  ResultadoNome : Array[TResultado] of string = ('Carta Alta', 'Um Par', 'Dois Pares', 'Trinca', 'Straight', 'Flush', 'Full House', 'Quadra', 'Straight Flush', 'Royal Flush');

implementation

{ TJogador }

procedure TJogador.BuscarMelhorResultado;
var
  i,j: Integer;
begin
  OrdenarMao;
//Carta Alta: A carta de maior valor.
  CartaAlta := Mao[0];

//    Um Par: Duas cartas do mesmo valor.
  for i := Low(Mao) to High(Mao) - 1 do
    if Mao[i].Valor = Mao[i + 1].Valor then
      begin
        Par[0] := Mao[i];
        Par[1] := Mao[i+1];
        Break;
      end;

//    Dois Pares: Dois pares diferentes.
  for i := Low(Mao) to High(Mao) - 1 do
    begin
      if (DoisPares[0] = nil) or (DoisPares[1] = nil) then
        begin
          if Mao[i].Valor = Mao[i + 1].Valor then
            begin
              DoisPares[0] := Mao[i];
              DoisPares[1] := Mao[i+1];
            end;
        end
      else
        begin
          if Mao[i].Valor = Mao[i + 1].Valor then
            begin
              DoisPares[2] := Mao[i];
              DoisPares[3] := Mao[i+1];
            end;
        end;
    end;

  ValidarResultado(DoisPares);

//    Trinca: Tr�s cartas do mesmo valor e duas de valores diferentes.
  for i := Low(Mao) to High(Mao) - 2 do
    if (Mao[i].Valor = Mao[i + 1].Valor) and (Mao[i].Valor = Mao[i + 2].Valor) then
      begin
        Trinca[0] := Mao[i];
        Trinca[1] := Mao[i+1];
        Trinca[2] := Mao[i+2];
        Break;
      end;

//    Straight (seq��ncia): Todas as carta com valores consecutivos.
  if (integer(Mao[1].Valor) = integer(Mao[0].Valor) - 1) and
     (integer(Mao[2].Valor) = integer(Mao[0].Valor) - 2) and
     (integer(Mao[3].Valor) = integer(Mao[0].Valor) - 3) and
     (integer(Mao[4].Valor) = integer(Mao[0].Valor) - 4) then
    for i := Low(Mao) to High(Mao) do
      Straight[i] := Mao[i];

//    Flush: Todas as cartas do mesmo naipe.
  if (Mao[1].Naipe = Mao[0].Naipe) and
     (Mao[2].Naipe = Mao[0].Naipe) and
     (Mao[3].Naipe = Mao[0].Naipe) and
     (Mao[4].Naipe = Mao[0].Naipe) then
    for i := Low(Mao) to High(Mao) do
      Flush[i] := Mao[i];

//    Full House: Um trinca e um par.
  for i := Low(Mao) to High(Mao) - 2 do
    if (Mao[i].Valor = Mao[i + 1].Valor) and (Mao[i].Valor = Mao[i + 2].Valor) then
      begin
        FullHouse[0] := Mao[i];
        FullHouse[1] := Mao[i+1];
        FullHouse[2] := Mao[i+2];
        j := i;
        Break;
      end;

  for i := Low(Mao) to High(Mao) - 1 do
    if (Mao[i].Valor = Mao[i + 1].Valor) and not ((j = i) or (j = (i + 1))) then
      begin
        FullHouse[3] := Mao[i];
        FullHouse[4] := Mao[i+1];
        Break;
      end;

  ValidarResultado(FullHouse);

//    Quadra: Quatro cartas do mesmo valor.
  for i := Low(Mao) to High(Mao) - 2 do
    if (Mao[i].Valor = Mao[i + 1].Valor) and (Mao[i].Valor = Mao[i + 2].Valor) and (Mao[i].Valor = Mao[i + 3].Valor) then
      begin
        Quadra[0] := Mao[i];
        Quadra[1] := Mao[i+1];
        Quadra[2] := Mao[i+2];
        Quadra[3] := Mao[i+3];
        Break;
      end;

//    Royal Flush: A seq��ncia 10, Valete, Dama, Rei, �s, do mesmo naipe.
  if (Mao[0].Valor = cA) and
     (Mao[1].Valor = cK) and
     (Mao[2].Valor = cQ) and
     (Mao[3].Valor = cJ) and
     (Mao[4].Valor = cT) and
     (Mao[1].Naipe = Mao[0].Naipe) and
     (Mao[2].Naipe = Mao[0].Naipe) and
     (Mao[3].Naipe = Mao[0].Naipe) and
     (Mao[4].Naipe = Mao[0].Naipe) then
    for i := Low(Mao) to High(Mao) do
      RoyalFlush[i] := Mao[i];

//    Straight Flush: Todas as cartas s�o consecutivas e do mesmo naipe.
  if (integer(Mao[1].Valor) = integer(Mao[0].Valor) - 1) and
     (integer(Mao[2].Valor) = integer(Mao[0].Valor) - 2) and
     (integer(Mao[3].Valor) = integer(Mao[0].Valor) - 3) and
     (integer(Mao[4].Valor) = integer(Mao[0].Valor) - 4) and
     (Mao[1].Naipe = Mao[0].Naipe) and
     (Mao[2].Naipe = Mao[0].Naipe) and
     (Mao[3].Naipe = Mao[0].Naipe) and
     (Mao[4].Naipe = Mao[0].Naipe) and
     (RoyalFlush[0] = nil) then
    for i := Low(Mao) to High(Mao) do
      StraightFlush[i] := Mao[i];

  FMelhorResultado := GetMelhorResultado;
end;

constructor TJogador.Create;
var
  i:integer;
  aCarta:TCarta;
begin
  Randomize;
  for i := 0 to 4 do
    begin
      aCarta := TCarta.Create;
      aCarta.Valor := TValor(random(integer(High(TValor))));
      aCarta.Naipe := TNaipe(random(integer(High(TNaipe))));
      Mao[i] := aCarta;
  end;
end;

destructor TJogador.Destroy;
begin
  Free;
end;

function TJogador.GetCartasMao: string;
var
  i:integer;
begin
  for i := Low(Mao) to High(Mao) do
    Result := Result + ' ' + Mao[i].Carta;
end;

function TJogador.GetMelhorResultado: TResultado;
begin
  if not (CartaAlta = nil) then
    result := rCartaAlta;
  if not (Par[0] = nil) then
    result := rUmPar;
  if not (DoisPares[0] = nil) then
    result := rDoisPares;
  if not (Trinca[0] = nil) then
    result := rTrinca;
  if not (Straight[0] = nil) then
    result := rStraight;
  if not (Flush[0] = nil) then
    result := rFlush;
  if not (FullHouse[0] = nil) then
    result := rFullHouse;
  if not (Quadra[0] = nil) then
    result := rQuadra;
  if not (StraightFlush[0] = nil) then
    result := rStraightFlush;
  if not (RoyalFlush[0] = nil) then
    result := rRoyalFlush;

  FResultadoNome := GetResultadoNome;
end;

function TJogador.GetResultadoNome: string;
var
  i:integer;
  r, rr:string;
begin
  r := GetEnumName(TypeInfo(TResultado), integer(FMelhorResultado));
  for i := 2 to length(r) do
    begin
      if r[i] = UpperCase(r[i]) then
        rr := rr + ' ';
      rr := rr + r[i];
    end;
  FResultadoNome := trim(rr);
  Result := FResultadoNome;
end;

procedure TJogador.OrdenarMao;
var
  i,j,k: Integer;
  MaoOrd : Array[0..4] of TCarta;
  aBaralho:TBaralho;
begin
  aBaralho := TBaralho.Create;

  k := 0;

  for i := High(aBaralho.Carta) downto Low(aBaralho.Carta) do
    for j := 0 to 4 do
      if (aBaralho.Carta[i].Valor = Mao[j].Valor) and (aBaralho.Carta[i].Naipe = Mao[j].Naipe) then
        begin
          MaoOrd[k] := Mao[j];
          Inc(k);
        end;
  for i := Low(MaoOrd) to High(maoOrd) do
    Mao[i] := MaoOrd[i];
end;

procedure TJogador.SetMelhorResultado(const Value: TResultado);
begin
  FMelhorResultado := Value;
end;

procedure TJogador.SetResultadoNome(const Value: string);
begin
  FResultadoNome := Value;
end;

procedure TJogador.ValidarResultado(var Tipo: array of TCarta);
var
  i: Integer;
  r:boolean;
begin
  r := False;
  for i := Low(Tipo) to High(Tipo) do
    r := (Tipo[i] = nil) and r;
  if not r then
  for i := Low(Tipo) to High(Tipo) do
    Tipo[i] := nil;
end;

{ TCarta }

function TCarta.CompararCom(aCarta: TCarta): integer;
begin
  if FValor = aCarta.Valor then
    begin
      if FNaipe = aCarta.Naipe then
        result := 0
      else
        if FNaipe > aCarta.Naipe then
          result := 1
        else
          result := -1;
    end
  else
    if FValor > aCarta.Valor then
      result := 1
    else
      result := -1;
end;

function TCarta.GetCarta: string;
begin
  Result := FCarta;
end;

procedure TCarta.SetNaipe(const Value: TNaipe);
begin
  FNaipe := Value;
  FCarta := GetEnumName(TypeInfo(TValor), integer(FValor))[2] + GetEnumName(TypeInfo(TNaipe), integer(FNaipe))[2];
end;

procedure TCarta.SetValor(const Value: TValor);
begin
  FValor := Value;
  FCarta := GetEnumName(TypeInfo(TValor), integer(FValor))[2] + GetEnumName(TypeInfo(TNaipe), integer(FNaipe))[2];
end;

procedure TCarta.SetPosicao(const Value: integer);
begin
  FPosicao := Value;
end;

{ TBaralho }

constructor TBaralho.Create;
var
  v, n, i:integer;
  aCarta: TCarta;
begin
  inherited;
  i := 0;
  SetLength(Carta, (integer(High(TValor)) + 1) * (integer(High(TNaipe)) + 1));
  for v := 0 to integer(High(TValor)) do
    for n := 0 to integer(High(TNaipe)) do
      begin
        aCarta := TCarta.Create;
        aCarta.Valor := TValor(v);
        aCarta.Naipe := TNaipe(n);
        aCarta.Posicao := i;
        Carta[i] := ACarta;
        inc(i);
      end;
end;

destructor TBaralho.Destroy;
begin
  inherited;
end;

end.
