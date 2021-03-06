{*******************************************************************************
*                                                                              *
*  TksSlideMenu - Slide Menu Component                                         *
*                                                                              *
*  https://github.com/gmurt/KernowSoftwareFMX                                  *
*                                                                              *
*  Copyright 2015 Graham Murt                                                  *
*                                                                              *
*  email: graham@kernow-software.co.uk                                         *
*                                                                              *
*  Licensed under the Apache License, Version 2.0 (the "License");             *
*  you may not use this file except in compliance with the License.            *
*  You may obtain a copy of the License at                                     *
*                                                                              *
*    http://www.apache.org/licenses/LICENSE-2.0                                *
*                                                                              *
*  Unless required by applicable law or agreed to in writing, software         *
*  distributed under the License is distributed on an "AS IS" BASIS,           *
*  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    *
*  See the License for the specific language governing permissions and         *
*  limitations under the License.                                              *
*                                                                              *
*******************************************************************************}

unit ksSlideMenu;

interface

{$IFDEF VER290}
  {$DEFINE XE8_OR_NEWER}
{$ENDIF}


uses System.UITypes, FMX.Controls, FMX.Layouts, FMX.Objects, System.Classes,
  FMX.Types, Generics.Collections, FMX.Graphics, System.UIConsts, FMX.Effects,
  FMX.StdCtrls, System.Types, FMX.ListBox, FMX.Forms
  {$IFDEF XE8_OR_NEWER}
  ,FMX.ImgList
  {$ENDIF}
  ;

const
  C_MENU_WIDTH = 250;

type
  TSelectMenuItemEvent = procedure(Sender: TObject; AId: string) of object;

  TksMenuPosition = (mpLeft, mpRight);
  TKsMenuStyle = (msOverlap, msReveal, msPush);

  TksSlideMenu = class;

  TksSlideMenuItem = class
  strict private
    FText: string;
    FId: string;
    FFont: TFont;
    FImage: TBitmap;
    FHeight: integer;
    FIndex: integer;
  public
    constructor Create(AIndex: integer); virtual;
    destructor Destroy; override;
    property Height: integer read FHeight write FHeight;
    property Index: integer read FIndex;
    property Font: TFont read FFont write FFont;
    property Image: TBitmap read FImage write FImage;
    property ID: string read FId write FId;
    property Text: string read FText write FText;
  end;

  TksSlideMenuItems = class(TObjectList<TksSlideMenuItem>)
  private
    function AddMenuItem(AId, AText: string; AImage: TBitmap): TksSlideMenuItem;
  end;


  TksSlideMenuToolbar = class(TPersistent)
  private
    FText: string;
    FBitmap: TBitmap;
    FVisible: Boolean;
    FHeaderColor: TAlphaColor;
    FHeight: integer;
    FTextColor: TAlphaColor;
    FFont: TFont;
    procedure SetFont(const Value: TFont);
  public
    constructor Create(AOwner: TComponent); virtual;
    destructor Destroy; override;
    procedure DrawToCanvas(ACanvas: TCanvas; ARect: TRectF);
    property Height: integer read FHeight default 44;
  published
    property Bitmap: TBitmap read FBitmap;
    property Visible: Boolean read FVisible write FVisible default True;
    property Color: TAlphaColor read FHeaderColor write FHeaderColor default TAlphaColor($FF323232);
    property Text: string read FText write FText;
    property TextColor: TAlphaColor read FTextColor write FTextColor default claWhite;
    property Font: TFont read FFont write SetFont;
  end;


  TksSlideMenuCanvas = class(TImage)
  strict private
    FBackgroundColor: TAlphaColor;
    FSelectedColor: TAlphaColor;
    FSelectedFontColor: TAlphaColor;
    FUnselectedFontColor: TAlphaColor;
    FSlideMenu: TksSlideMenu;
    FBitmap: TBitmap;
    FItems: TksSlideMenuItems;
    FItemHeight: integer;
    FItemIndex: integer;
    FOnSelectMenuItemEvent: TSelectMenuItemEvent;
    FAfterSelectMenuItemEvent: TSelectMenuItemEvent;
    function ItemAtPos(x, y: single): TksSlideMenuItem;
    procedure SetItemHeight(const Value: integer);
    procedure SetItemIndex(const Value: integer);
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Single); override;
  public
    constructor CreateWithItems(AOwner: TComponent; AItems: TksSlideMenuItems);
    destructor Destroy; override;
    procedure RedrawMenu(AddBorder: Boolean);
    property BackgroundColor: TAlphaColor read FBackgroundColor write FBackgroundColor default claNavy;
    property SelectedColor: TAlphaColor read FSelectedColor write FSelectedColor default claRed;
    property SelectedFontColor: TAlphaColor read FSelectedFontColor write FSelectedFontColor default claWhite;
    property UnselectedFontColor: TAlphaColor read FUnselectedFontColor write FUnselectedFontColor default claWhite;
    property ItemHeight: integer read FItemHeight write SetItemHeight default 40;
    property ItemIndex: integer read FItemIndex write SetItemIndex;
    // evnets..
    property AfterSelectMenuItemEvent: TSelectMenuItemEvent read FAfterSelectMenuItemEvent write FAfterSelectMenuItemEvent;
    property OnSelectMenuItemEvent: TSelectMenuItemEvent read FOnSelectMenuItemEvent write FOnSelectMenuItemEvent;
  end;


  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidiOSDevice or pidAndroid)]
  TksSlideMenu = class(TFmxObject)
  strict private
    FCanvas: TksSlideMenuCanvas;
    FItems: TksSlideMenuItems;
    FShadowLeft: TImage;
    FShadowRight: TImage;
    FBackground: TRectangle;
    FFormImage: TImage;
    FFont: TFont;
    FShowing: Boolean;
    {$IFDEF XE8_OR_NEWER}
    FImages: TImageList;
    {$ENDIF}
    FTopPadding: integer;
    FMenuPosition: TksMenuPosition;
    FMenuStyle: TKsMenuStyle;
    FSlideSpeed: Single;
    FOnSelectMenuItemEvent: TSelectMenuItemEvent;
    FAfterSelectMenuItemEvent: TSelectMenuItemEvent;
    FOnAfterSlideOut: TNotifyEvent;
  private
    FToolbar: TksSlideMenuToolbar;
    procedure SetItemHeight(const Value: integer);
    function GetItemHeight: integer;
    function GetItemIndex: integer;
    procedure SetItemIndex(const Value: integer);
    procedure SetTopPadding(const Value: integer);
    procedure DoBackgroundClick(Sender: TObject);
    procedure DoSelectMenuItemEvent(Sender: TObject; AId: string);
    procedure DoAfterSelectMenuItemEvent(Sender: TObject; AId: string);
    function GetSelectedFontColor: TAlphaColor;
    procedure SetSelectedFontColor(const Value: TAlphaColor);
    function GetUnSelectedFontColor: TAlphaColor;
    procedure SetUnSelectedFontColor(const Value: TAlphaColor);
    function GetBackgroundColor: TAlphaColor;
    function GetSelectedColor: TAlphaColor;
    procedure SetBackgroundColor(const Value: TAlphaColor);
    procedure SetSelectedColor(const Value: TAlphaColor);
    procedure ToggleOverlap;
    procedure TogglePush(ACacheFormImage: Boolean);
    procedure ToggleReveal(ACacheFormImage: Boolean);
    procedure FadeBackground;
    procedure UnfadeBackground;
    procedure GenerateFormImage(AForm: TForm);
    procedure GenerateShadows;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear;

    {$IFDEF XE8_OR_NEWER}
    function AddMenuItem(AId, AText: string; const AImageIndex: integer = -1): TksSlideMenuItem; overload;
    {$ENDIF}
    function AddMenuItem(AId, AText: string; AImage: TBitmap): TksSlideMenuItem; overload;
    procedure ToggleMenu;
    procedure UpdateMenu;
    procedure ShowForm(AForm: TForm);
    property Showing: Boolean read FShowing;
    //property FormImage: TImage
  published
    property Font: TFont read FFont write FFont;
    {$IFDEF XE8_OR_NEWER}
    property Images: TImageList read FImages write FImages;
    {$ENDIF}
    property ItemHeight: integer read GetItemHeight write SetItemHeight;
    property ItemIndex: integer read GetItemIndex write SetItemIndex;
    property TopPadding: integer read FTopPadding write SetTopPadding default 0;
    property BackgroundColor: TAlphaColor read GetBackgroundColor write SetBackgroundColor;
    property MenuPosition: TksMenuPosition read FMenuPosition write FMenuPosition default mpLeft;
    property MenuStyle: TKsMenuStyle read FMenuStyle write FMenuStyle default msReveal;
    property SelectedColor: TAlphaColor read GetSelectedColor write SetSelectedColor;
    property SelectedFontColor: TAlphaColor read GetSelectedFontColor write SetSelectedFontColor;
    property SlideSpeed: Single read FSlideSpeed write FSlideSpeed;
    property UnSelectedFontColor: TAlphaColor read GetUnSelectedFontColor write SetUnSelectedFontColor;
    property OnSelectMenuItemEvent: TSelectMenuItemEvent read FOnSelectMenuItemEvent write FOnSelectMenuItemEvent;
    property AfterSelectItemEvent: TSelectMenuItemEvent read FAfterSelectMenuItemEvent write FAfterSelectMenuItemEvent;
    property Toolbar: TksSlideMenuToolbar read FToolbar write FToolbar;
    property OnAfterSlideOut: TNotifyEvent read FOnAfterSlideOut write FOnAfterSlideOut;

  end;

  procedure Register;

implementation

uses FMX.Platform, SysUtils, FMX.Ani;

procedure Register;
begin
  RegisterComponents('Kernow Software FMX', [TksSlideMenu]);
end;

function GetScreenScale: Single;
var
   Service : IFMXScreenService;
begin
   Service := IFMXScreenService(
      TPlatformServices.Current.GetPlatformService(IFMXScreenService));
   Result := Service .GetScreenScale;
end;

{ TSlideMenu }

{$IFDEF XE8_OR_NEWER}

function TksSlideMenu.AddMenuItem(AId, AText: string; const AImageIndex: integer = -1): TksSlideMenuItem;
var
  AImage: TBitmap;
  ASize: TSizeF;
begin
  AImage := nil;
  ASize.Width := 64;
  ASize.Height := 64;
  if FImages <> nil then
    AImage := Images.Bitmap(ASize, AImageIndex);
  Result := AddMenuItem(AId, AText, AImage);
end;

{$ENDIF}

function TksSlideMenu.AddMenuItem(AId, AText: string; AImage: TBitmap): TksSlideMenuItem;
begin
  Result := FItems.AddMenuItem(AId, AText, AImage);
  Result.Font.Assign(FFont);
end;

procedure TksSlideMenu.Clear;
begin
  FItems.Clear;
  UpdateMenu;
end;

constructor TksSlideMenu.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFont := TFont.Create;
  FItems := TksSlideMenuItems.Create;
  FShadowLeft := TImage.Create(Self);
  FShadowRight := TImage.Create(Self);
  FCanvas := TksSlideMenuCanvas.CreateWithItems(Self, FItems);
  FToolbar := TksSlideMenuToolbar.Create(FCanvas);

  FShowing := False;
  FTopPadding := 0;
  FFont.Size := 14;
  FCanvas.OnSelectMenuItemEvent := DoSelectMenuItemEvent;
  FCanvas.AfterSelectMenuItemEvent := DoAfterSelectMenuItemEvent;
  FBackground := TRectangle.Create(Self);
  FFormImage := TImage.Create(Self);
  FFormImage.OnClick := DoBackgroundClick;
  FMenuPosition := mpLeft;
  FMenuStyle := msReveal;
  FSlideSpeed := 0.2;
  GenerateShadows;
end;

destructor TksSlideMenu.Destroy;
begin
  FFont.Free;
  FItems.Free;
  FToolbar.Free;

  if IsChild(FShadowLeft) then FShadowLeft.Free;
  if IsChild(FShadowRight) then FShadowRight.Free;
  if IsChild(FCanvas) then FCanvas.Free;
  if IsChild(FBackground) then FBackground.Free;
  if IsChild(FFormImage) then FFormImage.Free;
  inherited;
end;


procedure TksSlideMenu.DoBackgroundClick(Sender: TObject);
begin
  ToggleMenu;
end;

procedure TksSlideMenu.DoSelectMenuItemEvent(Sender: TObject; AId: string);
begin
  if Assigned(FOnSelectMenuItemEvent) then
    FOnSelectMenuItemEvent(Self, AId);
end;

procedure TksSlideMenu.DoAfterSelectMenuItemEvent(Sender: TObject; AId: string);
begin
  if Assigned(FAfterSelectMenuItemEvent) then
    FAfterSelectMenuItemEvent(Self, AId);
end;

procedure TksSlideMenu.FadeBackground;
begin
  FBackground.Fill.Color := claBlack;
  FBackground.Align := TAlignLayout.Contents;
  FBackground.OnClick := DoBackgroundClick;
  FBackground.Opacity := 0;
  TForm(Owner).AddObject(FBackground);
  TAnimator.AnimateFloat(FBackground, 'Opacity', 0.2, FSlideSpeed);
end;

procedure TksSlideMenu.GenerateFormImage(AForm: TForm);
var
  AScale: single;
  //AForm: TForm;
  ABmp: TBitmap;
begin
  FFormImage.Visible := false;
  FCanvas.Visible := False;
  ABmp := TBitmap.Create;
  try
    AScale := GetScreenScale;
    //AForm := (Owner as TForm);
    ABmp.BitmapScale := AScale;
    ABmp.Width := Round(AForm.Width * AScale);
    ABmp.Height := Round(AForm.Height * AScale);
    ABmp.Canvas.BeginScene;
    AForm.PaintTo(ABmp.Canvas);
    ABmp.Canvas.EndScene;
    ABmp.Canvas.BeginScene;
    ABmp.Canvas.Stroke.Color := claBlack;
    ABmp.Canvas.StrokeThickness := 1;
    ABmp.Canvas.DrawLine(PointF(0, 0), PointF(0, ABmp.Height), 1);
    ABmp.Canvas.EndScene;
    FFormImage.Width := Round(AForm.Width);
    FFormImage.Height := Round(AForm.Height);
    FFormImage.Bitmap.Assign(ABmp);
  finally
    ABmp.Free;
  end;
  FFormImage.Visible := True;
  FCanvas.Visible := True;
end;

procedure TksSlideMenu.GenerateShadows;
var
  AScale: single;
  AForm: TForm;
  ABmp: TBitmap;
begin
  ABmp := TBitmap.Create;
  try
    AScale := GetScreenScale;
    AForm := (Owner as TForm);
    ABmp.Width := Round(16 * AScale);
    ABmp.Height := Round(AForm.Height * AScale);
    ABmp.Canvas.BeginScene;
    ABmp.Canvas.Fill.Kind := TBrushKind.Gradient;
    ABmp.Canvas.Fill.Gradient.Color := claNull;
    ABmp.Canvas.Fill.Gradient.Color1 := $AA000000;
    ABmp.Canvas.Fill.Gradient.StartPosition.X := 0;
    ABmp.Canvas.Fill.Gradient.StartPosition.Y := 1;
    ABmp.Canvas.Fill.Gradient.StopPosition.X := 1;
    ABmp.Canvas.FillRect(RectF(0, 0, ABmp.Width, ABmp.Height), 0, 0, [], 1);
    ABmp.Canvas.EndScene;
    FShadowLeft.Width := 16;
    FShadowLeft.Height := Round(AForm.Height);
    FShadowLeft.Bitmap.Assign(ABmp);
  finally
    ABmp.Free;
  end;

  ABmp := TBitmap.Create;
  try
    AScale := GetScreenScale;
    AForm := (Owner as TForm);
    ABmp.Width := Round(16 * AScale);
    ABmp.Height := Round(AForm.Height * AScale);
    ABmp.Canvas.BeginScene;
    ABmp.Canvas.Fill.Kind := TBrushKind.Gradient;
    ABmp.Canvas.Fill.Gradient.Color := $AA000000;
    ABmp.Canvas.Fill.Gradient.Color1 := claNull;
    ABmp.Canvas.Fill.Gradient.StartPosition.X := 0;
    ABmp.Canvas.Fill.Gradient.StartPosition.Y := 1;
    ABmp.Canvas.Fill.Gradient.StopPosition.X := 1;
    ABmp.Canvas.FillRect(RectF(0, 0, ABmp.Width, ABmp.Height), 0, 0, [], 1);
    ABmp.Canvas.EndScene;
    FShadowRight.Width := 16;
    FShadowRight.Height := Round(AForm.Height);
    FShadowRight.Bitmap.Assign(ABmp);
  finally
    ABmp.Free;
  end;
end;
function TksSlideMenu.GetBackgroundColor: TAlphaColor;
begin
  Result := FCanvas.BackgroundColor;
end;

function TksSlideMenu.GetItemHeight: integer;
begin
  Result := FCanvas.ItemHeight;
end;

function TksSlideMenu.GetItemIndex: integer;
begin
  Result := FCanvas.ItemIndex;
end;

function TksSlideMenu.GetSelectedColor: TAlphaColor;
begin
  Result := FCanvas.SelectedColor;
end;

function TksSlideMenu.GetSelectedFontColor: TAlphaColor;
begin
  Result := FCanvas.SelectedFontColor;
end;

function TksSlideMenu.GetUnSelectedFontColor: TAlphaColor;
begin
  Result := FCanvas.UnselectedFontColor;
end;

procedure TksSlideMenu.SetBackgroundColor(const Value: TAlphaColor);
begin
  FCanvas.BackgroundColor := Value;
end;

procedure TksSlideMenu.SetItemHeight(const Value: integer);
begin
  FCanvas.ItemHeight := Value;
end;


procedure TksSlideMenu.SetItemIndex(const Value: integer);
begin
  FCanvas.ItemIndex := Value;
end;

procedure TksSlideMenu.SetSelectedColor(const Value: TAlphaColor);
begin
  FCanvas.SelectedColor := Value;
end;

procedure TksSlideMenu.SetSelectedFontColor(const Value: TAlphaColor);
begin
  FCanvas.SelectedFontColor := Value;
end;


procedure TksSlideMenu.SetTopPadding(const Value: integer);
begin
  FTopPadding := Value;
end;

procedure TksSlideMenu.SetUnSelectedFontColor(const Value: TAlphaColor);
begin
  FCanvas.UnselectedFontColor := Value;
end;

procedure TksSlideMenu.ShowForm(AForm: TForm);
begin
  GenerateFormImage(AForm);
end;

procedure TksSlideMenu.ToggleMenu;
begin
  if FCanvas.HitTest = False then
    Exit;


  FCanvas.HitTest := False;
  case FMenuStyle of
    msOverlap: ToggleOverlap;
    msPush: TogglePush(not FShowing);
    msReveal: ToggleReveal(not FShowing);
  end;
  FShowing := not FShowing;


  FCanvas.HitTest := True;
  if FShowing = False then
  begin
    if Assigned(FOnAfterSlideOut) then
      FOnAfterSlideOut(Self);
  end;
end;

procedure TksSlideMenu.ToggleOverlap;
var
  ANewX: Extended;
begin
  FCanvas.Width := C_MENU_WIDTH;
  if FShowing then
  begin
    ANewX := 0-FCanvas.Width;
    if FMenuPosition = mpRight then
      ANewX := (Owner as TForm).Width;
    UnfadeBackground;
    TAnimator.AnimateFloatWait(FCanvas, 'Position.X', ANewX, FSlideSpeed);
    TForm(Owner).RemoveObject(FCanvas);
    TForm(Owner).RemoveObject(FBackground);
  end
  else
  begin
    FCanvas.Height := (Owner as TForm).Height;
    FCanvas.Position.Y := FTopPadding;

    FCanvas.RedrawMenu(True);
    ANewX := 0;
    FCanvas.Position.X := 0-C_MENU_WIDTH;//FCanvas.Width;
    if FMenuPosition = mpRight then
    begin
      FCanvas.Position.X := TForm(Owner).Width;
      ANewX := (Owner as TForm).Width - FCanvas.Width;
    end;
    FadeBackground;
    TForm(Owner).AddObject(FCanvas);
    TAnimator.AnimateFloatWait(FCanvas, 'Position.X', ANewX, 0.2);

  end;
end;

procedure TksSlideMenu.TogglePush(ACacheFormImage: Boolean);
var
  ANewX: Extended;
begin
  if ACacheFormImage then
    GenerateFormImage(Owner as TForm);
  FCanvas.Width := C_MENU_WIDTH;
  if FShowing then
  begin
    ANewX := 0-C_MENU_WIDTH;
    if FMenuPosition = mpRight then
      ANewX := (Owner as TForm).Width;
    TAnimator.AnimateFloatWait(FCanvas, 'Position.X', ANewX, FSlideSpeed);
    FCanvas.RemoveObject(FFormImage);
    TForm(Owner).RemoveObject(FCanvas);
  end
  else
  begin
    FCanvas.Height := (Owner as TForm).Height;
    FCanvas.Position.Y := FTopPadding;
    FCanvas.RedrawMenu(False);
    ANewX := 0;
    FCanvas.Position.X := 0-C_MENU_WIDTH;
    FFormImage.Position.X := C_MENU_WIDTH;
    if FMenuPosition = mpRight then
    begin
      FCanvas.Position.X := TForm(Owner).Width;
      ANewX := (Owner as TForm).Width - C_MENU_WIDTH;
      FFormImage.Position.X := 0-FFormImage.Width;

    end;
    FCanvas.AddObject(FFormImage);
    TForm(Owner).AddObject(FCanvas);
    TAnimator.AnimateFloatWait(FCanvas, 'Position.X', ANewX, FSlideSpeed);
  end;
end;

procedure TksSlideMenu.ToggleReveal(ACacheFormImage: Boolean);
var
  ANewX: Extended;
  AShadow: TImage;
begin
  if ACacheFormImage then
    GenerateFormImage(Owner as TForm);

  AShadow := nil;
  case FMenuPosition of
    mpLeft: AShadow := FShadowLeft;
    mpRight: AShadow := FShadowRight;
  end;

  FCanvas.Width := C_MENU_WIDTH;
  if FShowing then
  begin
    ANewX := 0;
    TAnimator.AnimateFloatWait(FFormImage, 'Position.X', ANewX, FSlideSpeed);
    TForm(Owner).RemoveObject(FFormImage);
    TForm(Owner).RemoveObject(FCanvas);
    FFormImage.RemoveObject(FShadowLeft);
    FFormImage.RemoveObject(FShadowRight);
  end
  else
  begin
    AShadow.Position.X := 0-16;
    FCanvas.Height := (Owner as TForm).Height;
    FCanvas.Position.Y := FTopPadding;
    FCanvas.RedrawMenu(False);
    FCanvas.Position.X := 0;
    ANewX := C_MENU_WIDTH;
    if FMenuPosition = mpRight then
    begin
      FCanvas.Position.X := TForm(Owner).Width-C_MENU_WIDTH;
      AShadow.Position.X := TForm(Owner).Width;

      ANewX := 0-C_MENU_WIDTH;
    end;
    TForm(Owner).AddObject(FCanvas);
    TForm(Owner).AddObject(FFormImage);
    {$IFNDEF ANDROID}
    FFormImage.AddObject(AShadow);
    {$ENDIF}

    TAnimator.AnimateFloatWait(FFormImage, 'Position.X', ANewX,  FSlideSpeed);
  end;
  Application.ProcessMessages;
end;

procedure TksSlideMenu.UnfadeBackground;
begin
  TAnimator.AnimateFloat(FBackground, 'Opacity', 0, FSlideSpeed);
  //FBackground.AnimateFloat('Opacity', 0, FSlideSpeed);
end;

procedure TksSlideMenu.UpdateMenu;
begin
  FCanvas.RedrawMenu(FMenuStyle = msOverlap);
end;

{ TksSlideMenuItem }

constructor TksSlideMenuItem.Create(AIndex: integer);
begin
  inherited Create;
  FImage := TBitmap.Create;
  FFont := TFont.Create;
  FIndex := AIndex;
end;

destructor TksSlideMenuItem.Destroy;
begin
  FImage.Free;
  FFont.Free;
  inherited;
end;


{ TksSlideMenuItems }

function TksSlideMenuItems.AddMenuItem(AId, AText: string; AImage: TBitmap): TksSlideMenuItem;
begin
  Result := TksSlideMenuItem.Create(Count);
  if AImage <> nil then
    Result.Image.Assign(AImage);
  Result.Id := AId;
  Result.Text := AText;
  Add(Result);
end;

{ TksSlideMenuCanvas }

constructor TksSlideMenuCanvas.CreateWithItems(AOwner: TComponent; AItems: TksSlideMenuItems);
begin
  inherited Create(AOwner);
  FSlideMenu := (AOwner as TksSlideMenu);
  FBitmap := TBitmap.Create;
  FItems := AItems;
  Position.X := -C_MENU_WIDTH;
  Width := C_MENU_WIDTH;
  Top := 0;
  FItemHeight := 44;
  FItemIndex := -1;
  WrapMode := TImageWrapMode.Original;
  MarginWrapMode := TImageWrapMode.Original;
  FBackgroundColor := claNavy;
  FSelectedColor := claRed;
  FSelectedFontColor := claWhite;
  FUnselectedFontColor := claWhite;
end;

destructor TksSlideMenuCanvas.Destroy;
begin
  FBitmap.Free;

  inherited;
end;


procedure TksSlideMenuCanvas.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Single);
var
  AItem: TksSlideMenuItem;
begin
  if HitTest = False then
    Exit;
  AItem := ItemAtPos(X, Y);
  if AItem <> nil then
  begin
    ItemIndex := AItem.Index;
    RedrawMenu(FSlideMenu.MenuStyle = msOverlap);
    Application.ProcessMessages;

    if Assigned(FOnSelectMenuItemEvent) then
      FOnSelectMenuItemEvent(FSlideMenu, AItem.Id);

    ///FSlideMenu.
    //FSlideMenu.GenerateFormImage(Owner as TForm);
    FSlideMenu.GenerateFormImage(FSlideMenu.Owner as TForm);
    Application.ProcessMessages;
    //FSlideMenu.
    Sleep(100);
    FSlideMenu.ToggleMenu;

    if Assigned(FAfterSelectMenuItemEvent) then
      FAfterSelectMenuItemEvent(FSlideMenu, AItem.Id);
  end;

end;

procedure TksSlideMenuCanvas.RedrawMenu(AddBorder: Boolean);
var
  ARect: TRectF;
  ICount: integer;
  ABmpRect: TRectF;
  AScale: single;
  AToolbarRect: TRectF;
  ABmp: TBitmap;
begin
  ABmp := fBitmap;
  try
    AScale := GetScreenScale;
    ABmp.BitmapScale := AScale;
    ABmp.Width := Round(Width * AScale);
    ABmp.Height := Round(Height * AScale);
    Application.ProcessMessages;
    ABmp.Canvas.BeginScene;
    ABmp.Canvas.Fill.Color := FBackgroundColor;
    ABmp.Canvas.FillRect(ClipRect, 0, 0, [], 1);
    ARect := RectF(0, 0, C_MENU_WIDTH, FItemHeight);
    ABmp.Canvas.Fill.Color := FBackgroundColor;
    ABmp.Canvas.Stroke.Color := claBlack;

    // draw toolbar...
    AToolbarRect := ARect;
    AToolbarRect.Height := FSlideMenu.Toolbar.Height;

    if FSlideMenu.Toolbar.Visible then
    begin
      FSlideMenu.Toolbar.DrawToCanvas(ABmp.Canvas, AToolbarRect);
      OffsetRect(ARect, 0, 44);
    end;

    for ICount := 0 to FItems.Count-1 do
    begin

      ABmp.Canvas.Fill.Color := FBackgroundColor;
      if FItemIndex = ICount then
        ABmp.Canvas.Fill.Color := FSelectedColor;

      ARect.Left := 0;
      ABmp.Canvas.FillRect(ARect, 0, 0, [], 1);

      if FItemIndex <> ICount then
      begin
        ABmp.Canvas.Fill.Color := FSlideMenu.Toolbar.Color;
        ABmp.Canvas.FillRect(RectF(ARect.Left+32, ARect.Bottom-1, ARect.Right, ARect.Bottom), 0, 0, [], 1);
      end;

      ABmp.Canvas.Fill.Color := claBlack;

      if AddBorder then
      begin
        ABmp.Canvas.Stroke.Thickness := 1;
        // left/right menu border...
        if FSlideMenu.MenuPosition = mpLeft then
          ABmp.Canvas.DrawLine(PointF(C_MENU_WIDTH/AScale, 0), PointF(C_MENU_WIDTH/AScale, Height), 1)
        else
          ABmp.Canvas.DrawLine(PointF(0, 0), PointF(0, Height), 1);
      end;

      if FItems[ICount].Image <> nil then
      begin
        ABmpRect := RectF(0, 0, 24, 24);
        OffsetRect(ABmpRect, 4, ARect.Top+((FItemHeight-24) div 2));
        ABmp.Canvas.DrawBitmap(FItems[ICount].Image, RectF(0,0,64,64), ABmpRect, 1);
      end;
      ARect.Left := 36;
      ABmp.Canvas.Fill.Color := FUnselectedFontColor;
      if FItemIndex = ICount then
        ABmp.Canvas.Fill.Color := FSelectedFontColor;
      ABmp.Canvas.Font.Assign(FItems[ICount].Font);
      ABmp.Canvas.FillText(ARect, FItems[ICount].Text, False, 1, [], TTextAlign.Leading, TTextAlign.Center);
      OffsetRect(ARect, 0, FItemHeight);
    end;
    ABmp.Canvas.EndScene;
    Bitmap := ABmp;
  finally
  end;
end;

procedure TksSlideMenuCanvas.SetItemHeight(const Value: integer);
begin
  FItemHeight := Value;
end;

procedure TksSlideMenuCanvas.SetItemIndex(const Value: integer);
begin
  FItemIndex := Value;
  //RedrawMenu(FSlideMenu.MenuStyle = msOverlap);
end;


function TksSlideMenuCanvas.ItemAtPos(x, y: single): TksSlideMenuItem;
var
  AIndex: integer;
begin
  Result := nil;
  if FSlideMenu.Toolbar.Visible then
    y := y - FSlideMenu.Toolbar.Height;
  if y < 1 then
    Exit;
  AIndex := Trunc(y / FItemHeight);
  if AIndex < FItems.Count then
    Result := FItems[AIndex];
end;


{ TksSlideMenuToolbar }

constructor TksSlideMenuToolbar.Create(AOwner: TComponent);
begin
  inherited Create;
  FBitmap := TBitmap.Create;
  FHeaderColor := TAlphaColor($FF323232);
  FTextColor := claWhite;
  FFont := TFont.Create;
  FFont.Size := 14;
  FHeight := 44;
  FVisible := True;
end;

destructor TksSlideMenuToolbar.Destroy;
begin
  FBitmap.Free;
  FFont.Free;
  inherited;
end;

procedure TksSlideMenuToolbar.DrawToCanvas(ACanvas: TCanvas; ARect: TRectF);
var
  AImageRect: TRectF;
  ATextRect: TRectF;
begin
  AImageRect := RectF(0, 0, 24, 24);
  ACanvas.Fill.Color := FHeaderColor;
  ACanvas.FillRect(ARect, 0, 0, [], 1);
  OffsetRect(AImageRect, 10, 10);
  ACanvas.DrawBitmap(FBitmap, RectF(0, 0, FBitmap.Width, FBitmap.Height), AImageRect, 1);
  ACanvas.Fill.Color := FTextColor;
  ATextRect := ARect;
  ATextRect.Left := 50;
  ACanvas.Font.Assign(FFont);
  ACanvas.FillText(ATextRect, FText, False, 1, [], TTextAlign.Leading);
  ACanvas.Stroke.Color := claBlack;
  ACanvas.DrawLine(PointF(0, ARect.Bottom), PointF(ARect.Right, ARect.Bottom), 1);
end;

procedure TksSlideMenuToolbar.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
end;

end.

