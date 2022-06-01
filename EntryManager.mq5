//+------------------------------------------------------------------+
//|                                                 JadeEntryManager.mq4 |
//|                                                      JadeCapital |
//|                                      https://www.jadecapital.com |
//+------------------------------------------------------------------+
#property strict
#include <Controls\RadioGroup.mqh>;
#include <Controls\Button.mqh>;

string ORDER_BUTTON_NAME = "OrderButton";
string ORDER_TWICE_BUTTON_NAME = "OrderButtonTwice";
string BE_BUTTON_NAME = "BEButton";
string DELETE_BUTTON_NAME = "DeleteButton";
double risk_percent = 0.5;
double stop_loss = 10.2; //pips need to change to stoploss
double entry_price = 0.00001;
double spreadInPoints = 0;
double currentPrice, spread, lots, stoploss, entryPlusSpread;

int orderTypeVal = 0;
int limitOrderTypeVal = 0;
int orderExecTypeVal = 0;

int magicNumber = 3238;
int slippage = 2;

bool radioGroup2Created = false;
bool radioGroup3Created = false;

CRadioGroup m_radioGroup1;
CRadioGroup m_radioGroup2;
CRadioGroup m_radioGroup3;
CButton button;

int OnInit()
{   
   GUI_Build();
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
   m_radioGroup1.Destroy();
   m_radioGroup2.Destroy();
   m_radioGroup3.Destroy();
}

void OnTick()
{
   //onClick();   
}

void GUI_Build()
{  
   // Risk Text Field
   CreateLabel("risk_percent_label", 10, 20, "Risk % (*)");
   CreateTextField("risk_percent", 140, 30, 10, 50, "0.5");
   
   // stop loss price Text Field
   CreateLabel("stop_loss_pips_label", 160, 20, "Stop Loss - Pips (*)");
   CreateTextField("stop_loss_pips", 140, 30, 160, 50, "2.1");

   // order type radio button
   int labelxsize[2] = {40, 40};
   int labelysize[2] = {190, 210};
   int buttonxsize[2] = {20, 20};
   int buttonysize[2] = {190, 210};
   
   string radio_buttons[2] = {"Market Execution", "Limit Order"};
   CreateLabel("order_type_label", 10, 160, "Order Type");
   CreateRadioGroup(m_radioGroup1, 2, radio_buttons, "OrderType", labelxsize, labelysize, buttonxsize, buttonysize);
  
   
   CreateOrderExecutionRadioButton();
   
   ReorderRadioButtonsOnChange(0);
   DestroyEntryPriceTextField();
   
   // Order Button
   CreateButton("Place Order", clrWhite, clrGreen, clrBlack, 180, 250, ORDER_BUTTON_NAME, 10, 0, 140, 50);
   CreateButton("Place Order x2", clrWhite, clrBlue, clrBlack, 10, 250, ORDER_TWICE_BUTTON_NAME, 10, 0, 140, 50);
   CreateButton("Close [P | O]", clrBlack, clrWhiteSmoke, clrBlack, 10, 310, DELETE_BUTTON_NAME, 10, 0, 140, 50);
   CreateButton("Break Even", clrBlack, clrWhiteSmoke, clrBlack, 180, 310, BE_BUTTON_NAME, 10, 0, 140, 50);
}

void CreateEntryPriceTextField()
{
   // entry price Text Field
   CreateLabel("entry_price_label", 10, 90, "Entry Price");
   CreateTextField("entry_price", 300, 30, 10, 120, "0.00001");
}

void DestroyEntryPriceTextField()
{
   ObjectDelete(0, "entry_price_label");
   ObjectDelete(0, "entry_price");
}

void CreateLimitOrderTypeRadio()
{
   // limit order type radio button
   string lot_radio_buttons[4] = {"Buy Stop", "Sell Stop", "Buy Limit", "Sell Limit"};
   
   int labelxsize[4] = {40, 40, 40, 40};
   int labelysize[4] = {260, 280, 300, 320};
   int buttonxsize[4] = {20, 20, 20, 20};
   int buttonysize[4] = {260, 280, 300, 320};
   
   CreateLabel("limit_order_type_label", 10, 240, "Limit Order Type");
   CreateRadioGroup(m_radioGroup2, 4, lot_radio_buttons, "LimitOrderType", labelxsize, labelysize, buttonxsize, buttonysize);
}


void CreateOrderExecutionRadioButton()
{
   // type of order type radio button
   string _radio_buttons[2] = {"Buy", "Sell"};
   
   int labelxsize[2] = {40, 40};
   int labelysize[2] = {260, 280};
   int buttonxsize[2] = {20, 20};
   int buttonysize[2] = {260, 280};
   
   CreateLabel("order_execution_type_label", 10, 165, "Order Execution Type");
   CreateRadioGroup(m_radioGroup3, 2, _radio_buttons, "OrderExecutionType", labelxsize, labelysize, buttonxsize, buttonysize);
}

void CreateButton(string _text, color _textColor, color _bg, color _brdrColor, int _xDistance, int _yDistance, string buttonName, int x1, int y1, int x2, int y2)
{
   button.Create(0, buttonName, 0, x1, y1, x2, y2);
   button.Text(_text);
   button.FontSize(10);
   button.Color(_textColor);
   button.ColorBorder(_brdrColor);
   button.ColorBackground(_bg);
   ObjectSetInteger(0, buttonName, OBJPROP_XDISTANCE, _xDistance);
   ObjectSetInteger(0, buttonName, OBJPROP_YDISTANCE, _yDistance);
}

void CreateTextField(string field_name, int xsize, int ysize, int xdistance, int ydistance, string default_text)
{
   ObjectCreate(0, field_name, OBJ_EDIT, 0, 0, 0);
   ObjectSetInteger(0, field_name, OBJPROP_XSIZE, xsize);
   ObjectSetInteger(0, field_name, OBJPROP_YSIZE, ysize);
   ObjectSetInteger(0, field_name, OBJPROP_XDISTANCE, xdistance);
   ObjectSetInteger(0, field_name, OBJPROP_YDISTANCE, ydistance);
   ObjectSetInteger(0, field_name, OBJPROP_BGCOLOR, clrWhite);
   ObjectSetInteger(0, field_name, OBJPROP_COLOR, clrBlack);
   ObjectSetString(0, field_name, OBJPROP_TEXT, default_text);
}

void CreateLabel(string field_name, int xdistance, int ydistance, string label_name)
{
   ObjectCreate(0, field_name, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, field_name, OBJPROP_XDISTANCE, xdistance);
   ObjectSetInteger(0, field_name, OBJPROP_YDISTANCE, ydistance);
   ObjectSetString(0, field_name,OBJPROP_TEXT,label_name);
   ObjectSetInteger(0, field_name, OBJPROP_COLOR, clrBlack);
}


bool CreateRadioGroup(CRadioGroup& radioGroup, int count, string& radio_buttons[], string group_name, int& labelxsize[],
   int& labelysize[],
   int& buttonxsize[],
   int& buttonysize[])
{
   radioGroup.Create(0, group_name, 0, 20, 20, 300, 100);   
   RadioGroupPositioning(count, group_name, labelxsize, labelysize, buttonxsize, buttonysize);
   
   for(int i=0; i < count; i++)
      if(!radioGroup.AddItem(radio_buttons[i], i)) return(false);

   radioGroup.Value(0);
   radioGroup3Created = true;
   return(true);
}

void RadioGroupPositioning(
   int count,
   string group_name,
   int& labelxsize[],
   int& labelysize[],
   int& buttonxsize[],
   int& buttonysize[]
)
{
   ObjectSetInteger(0, group_name + "Back", OBJPROP_XSIZE, 0);
   ObjectSetInteger(0, group_name + "Back", OBJPROP_YSIZE, 0);
   
   for (int i = 0; i < count; i++) 
   {
      ObjectSetInteger(0, group_name + "Item" + (string)i + "Label", OBJPROP_XDISTANCE, labelxsize[i]);
      ObjectSetInteger(0, group_name + "Item" + (string)i + "Label", OBJPROP_YDISTANCE, labelysize[i]);
      //---
      ObjectSetInteger(0, group_name + "Item" + (string)i + "Button", OBJPROP_XDISTANCE, buttonxsize[i]);
      ObjectSetInteger(0, group_name + "Item" + (string)i + "Button", OBJPROP_YDISTANCE, buttonysize[i]);
   }
   
}

void RadioButtonOnChangeEvent(int id, string sparam, int count, string& item[], string type) 
{
   if (id == CHARTEVENT_OBJECT_CLICK)
   {
      for (int i = 0; i < count; i++) 
      {
         if (sparam == item[i]) 
         {
            bool selected = ObjectGetInteger(0,sparam,OBJPROP_STATE);
            ObjectSetInteger(0,sparam,OBJPROP_STATE, 1);
            
            if(type == "OrderType") orderTypeVal = i;
            else if(type == "LimitOrderType") limitOrderTypeVal = i;
            else if(type == "OrderExecutionType") orderExecTypeVal = i;
            
            if(selected)
            {
               for (int j = 0; j < count; j++)
                  if(sparam != item[j]) ObjectSetInteger(0, item[j], OBJPROP_STATE, false);
               
               ChartRedraw();
               return;
            }
            ChartRedraw();
            return;
         }
      }
   }
}

void ReorderRadioButtonsOnChange(int order)
{
   if (order == 0)
   {
      int orderTypeLabelxsize[2] = {40, 40};
      int orderTypeLabelysize[2] = {120, 140};
      int orderTypeButtonxsize[2] = {20, 20};
      int orderTypeButtonysize[2] = {120, 140};
      
      int orderExecutionTypeLabelxsize[2] = {40, 40};
      int orderExecutionTypeLabelysize[2] = {190, 210};
      int orderExecutionTypeButtonxsize[2] = {20, 20};
      int orderExecutionTypeButtonysize[2] = {190, 210};
      
      ObjectSetInteger(0, "order_type_label", OBJPROP_YDISTANCE, 90);
      
      RadioGroupPositioning(2, "OrderType", orderTypeLabelxsize, orderTypeLabelysize, orderTypeButtonxsize, orderTypeButtonysize);
      RadioGroupPositioning(2, "OrderExecutionType", orderExecutionTypeLabelxsize, orderExecutionTypeLabelysize, orderExecutionTypeButtonxsize, orderExecutionTypeButtonysize);
   
   } 
   else
   {
      int orderTypeLabelxsize[2] = {40, 40};
      int orderTypeLabelysize[2] = {190, 210};
      int orderTypeButtonxsize[2] = {20, 20};
      int orderTypeButtonysize[2] = {190, 210};
      
      int orderExecutionTypeLabelxsize[2] = {40, 40};
      int orderExecutionTypeLabelysize[2] = {260, 280};
      int orderExecutionTypeButtonxsize[2] = {20, 20};
      int orderExecutionTypeButtonysize[2] = {260, 280};
      
      ObjectSetInteger(0, "order_type_label", OBJPROP_YDISTANCE, 160);
      
      RadioGroupPositioning(2, "OrderType", orderTypeLabelxsize, orderTypeLabelysize, orderTypeButtonxsize, orderTypeButtonysize);
      RadioGroupPositioning(2, "OrderExecutionType", orderExecutionTypeLabelxsize, orderExecutionTypeLabelysize, orderExecutionTypeButtonxsize, orderExecutionTypeButtonysize);
   
   }
  
}

void OrderTypeRadioButtonItemEvent(int id, string sparam)
{
   string item[2] = {"OrderTypeItem0Button", "OrderTypeItem1Button"};
   RadioButtonOnChangeEvent(id, sparam, 2, item, "OrderType");
   
   if(orderTypeVal == 1 && !radioGroup2Created && radioGroup3Created) 
   {
      CreateLimitOrderTypeRadio();
      CreateEntryPriceTextField();
      ReorderRadioButtonsOnChange(1);
      
      radioGroup2Created = true;
      radioGroup3Created = false;
      m_radioGroup3.Destroy();
      
      ObjectDelete(0, "order_execution_type_label");
      ObjectSetInteger(0, ORDER_BUTTON_NAME, OBJPROP_YDISTANCE, 360);
      ObjectSetInteger(0, ORDER_TWICE_BUTTON_NAME, OBJPROP_YDISTANCE, 360);
      ObjectSetInteger(0, BE_BUTTON_NAME, OBJPROP_YDISTANCE, 420);
      ObjectSetInteger(0, DELETE_BUTTON_NAME, OBJPROP_YDISTANCE, 420);
   }
   
   else if (orderTypeVal == 0 && radioGroup2Created && !radioGroup3Created) 
   {
      CreateOrderExecutionRadioButton();
      ReorderRadioButtonsOnChange(0);
   
      ObjectDelete(0, "limit_order_type_label");
      ObjectSetInteger(0, ORDER_BUTTON_NAME, OBJPROP_YDISTANCE, 250);
      ObjectSetInteger(0, ORDER_TWICE_BUTTON_NAME, OBJPROP_YDISTANCE, 250);
      ObjectSetInteger(0, BE_BUTTON_NAME, OBJPROP_YDISTANCE, 310);
      ObjectSetInteger(0, DELETE_BUTTON_NAME, OBJPROP_YDISTANCE, 310);
      DestroyEntryPriceTextField();
      
      radioGroup2Created = false;
      radioGroup3Created = true;
      m_radioGroup2.Destroy();
   }
}

void LimitOrderTypeRadioButtonItemEvent(int id, string sparam)
{
   string item[4] = {"LimitOrderTypeItem0Button", "LimitOrderTypeItem1Button", "LimitOrderTypeItem2Button", "LimitOrderTypeItem3Button"};
   RadioButtonOnChangeEvent(id, sparam, 4, item, "LimitOrderType");
}

void OrderExecutionTypeRadioButtonItemEvent(int id, string sparam)
{
   string item[2] = {"OrderExecutionTypeItem0Button", "OrderExecutionTypeItem1Button"};
   RadioButtonOnChangeEvent(id, sparam, 2, item, "OrderExecutionType");
}

void Order(string buttonName)
{
   if (bool(ObjectGetInteger(0, buttonName, OBJPROP_STATE)))
   {
      string risk_percent_string = ObjectGetString(0, "risk_percent", OBJPROP_TEXT);
      risk_percent = StringToDouble(risk_percent_string);
      
      string stop_loss_string = ObjectGetString(0, "stop_loss_pips", OBJPROP_TEXT);
      stop_loss = StringToDouble(stop_loss_string);
      
      if (ObjectFind(0, "entry_price") == 0)
      {         
         string entry_price_string = ObjectGetString(0, "entry_price", OBJPROP_TEXT);
         entry_price = StringToDouble(entry_price_string);
      }
      double Ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
      double Bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
      
      spread = CalculateSpread(Ask, Bid);
      lots = GetLots();
      stoploss = orderTypeVal == 0 && radioGroup3Created ? 
                        orderExecTypeVal == 0 ? 
                        Ask - PipsToPrice(stop_loss) : 
                        Bid + PipsToPrice(stop_loss) + spread : 
                        limitOrderTypeVal == 0 || limitOrderTypeVal == 2 ? 
                        entry_price - PipsToPrice(stop_loss) :
                        entry_price + (PipsToPrice(stop_loss) + spread);
                        
      entryPlusSpread = entry_price + spread;
      
      int ticket = 0;
      int ticketType = 0;
      
      MqlTradeRequest request={};
      MqlTradeResult  result={};
                        
      if (orderTypeVal == 0 && radioGroup3Created) 
      {
         ticketType = orderExecTypeVal == 0 ? ORDER_TYPE_BUY : ORDER_TYPE_SELL;
         currentPrice = orderExecTypeVal == 0 ? Ask : Bid;
         
         request.action = TRADE_ACTION_DEAL;
         request.symbol = Symbol();
         request.volume = lots;
         request.type = ticketType;
         request.price = currentPrice;
         request.deviation = slippage;
         request.magic = magicNumber;
         request.sl = stoploss;
         
         if (buttonName == ORDER_TWICE_BUTTON_NAME)
               for (int i=0; i<2; i++)
               {
                  ticket = OrderSend(request,result);
                  ticketState(ticket);
               }
         else 
         {
            ticket = OrderSend(request, result);
            ticketState(ticket);
         }
      }      
      if (orderTypeVal == 1 && radioGroup2Created)
      {
         ticketType = limitOrderTypeVal == 0 ? ORDER_TYPE_BUY_STOP : limitOrderTypeVal == 1 ? ORDER_TYPE_SELL_STOP : limitOrderTypeVal == 2 ? ORDER_TYPE_BUY_LIMIT : limitOrderTypeVal == 3 ? ORDER_TYPE_SELL_LIMIT : NULL;
         
         request.action = TRADE_ACTION_PENDING;
         request.symbol = Symbol();
         request.volume = lots;
         request.type = ticketType;
         request.price = limitOrderTypeVal == 0 || limitOrderTypeVal == 2 ? entryPlusSpread : entry_price;
         request.deviation = slippage;
         request.magic = magicNumber;
         request.sl = stoploss;
         
         if (buttonName == ORDER_TWICE_BUTTON_NAME) 
               for (int i=0; i<2; i++)
               {
                  ticket = OrderSend(request, result);
                  ticketState(ticket);
               }
         else 
         {
            ticket = OrderSend(request, result);
            ticketState(ticket);
         }
      }
      
      ObjectSetInteger(0, buttonName, OBJPROP_STATE, false);
   }
}

void ticketState(int ticket)
{
   if(ticket == -1) {
      PlaySound("timeout.wav");
      Alert("An error has occured: Error-" + IntegerToString(GetLastError()));
   }
   else PlaySound("Ok.wav");
}

string priceStatus()
{
   return PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY ? "buy" : "sell";
}



void CloseTrades()
{
   MqlTradeRequest request;
   MqlTradeResult  result;
   int total = OrdersTotal() + PositionsTotal();
   
   //--- Don't close open positions and orders at the same time.
   
   
   if (bool(ObjectGetInteger(0, DELETE_BUTTON_NAME, OBJPROP_STATE)))
   {
      if (total == 0) Alert("There are no executed orders!");
      
      for(int i=total - 1; i >= 0; i--)
      {
         ulong magic = 0;
         ulong  order_ticket=OrderGetTicket(i);
         ulong  position_ticket=PositionGetTicket(i);
         string position_symbol=PositionGetString(POSITION_SYMBOL);
         int    digits=(int)SymbolInfoInteger(position_symbol,SYMBOL_DIGITS);
         double volume=PositionGetDouble(POSITION_VOLUME);
         ENUM_POSITION_TYPE type=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
         
         if (OrdersTotal() > 0)magic=OrderGetInteger(ORDER_MAGIC);
         if (PositionsTotal() > 0) magic=PositionGetInteger(POSITION_MAGIC);
         
         if ((OrderGetString(ORDER_SYMBOL) == Symbol() && magic == magicNumber) || (PositionGetString(POSITION_SYMBOL) == Symbol() && magic == magicNumber))
         {
            ZeroMemory(request);
            ZeroMemory(result);
            
            if (OrdersTotal() > 0) {
               request.action=TRADE_ACTION_REMOVE;                   // type of trade operation
               request.order = order_ticket;
            }
            if (PositionsTotal() > 0) {
               request.action   =TRADE_ACTION_DEAL;        // type of trade operation
               request.position =position_ticket;          // ticket of the position
               request.symbol   =position_symbol;          // symbol 
               request.volume   =volume;                   // volume of the position
               request.deviation=5;                        // allowed deviation from the price
               request.magic    =magicNumber; 
               if(type == POSITION_TYPE_BUY)
               {
                  request.price=SymbolInfoDouble(position_symbol,SYMBOL_BID);
                  request.type =ORDER_TYPE_SELL;
               }
               else
               {
                  request.price=SymbolInfoDouble(position_symbol,SYMBOL_ASK);
                  request.type =ORDER_TYPE_BUY;
               }
            }
            
            if (!OrderSend(request, result)) Alert("An error occured when closing | Error Code - ", GetLastError());
            else PlaySound("Ok.wav");               
         }
         else Alert("Sorry the \"order symbol\" is not equal to the symbol you are clicking on! You need to click on ", OrderGetString(ORDER_SYMBOL), " to close trades");
      }
      ObjectSetInteger(0, DELETE_BUTTON_NAME, OBJPROP_STATE, false);
   }
}

void ModifyTrades()
{
   if (bool(ObjectGetInteger(0, BE_BUTTON_NAME, OBJPROP_STATE)))
   {
      MqlTradeRequest request;
      MqlTradeResult  result;
      for (int i=0; i < PositionsTotal(); i++)
      {
         ulong  position_ticket=PositionGetTicket(i);
         string position_symbol=PositionGetString(POSITION_SYMBOL);
         
         if (position_symbol == Symbol() && PositionGetInteger(POSITION_MAGIC) == magicNumber)
         {
            if (priceState(priceStatus(), PositionGetDouble(POSITION_PRICE_OPEN))){
               ZeroMemory(request);
               ZeroMemory(result);
               
               request.action = TRADE_ACTION_SLTP;
               request.position = position_ticket;
               request.symbol = position_symbol;
               request.magic = magicNumber;
               request.sl = PositionGetDouble(POSITION_PRICE_OPEN);
               
               if (!OrderSend(request, result)) Alert("An error occured on Position ticket-", position_ticket, " | Error Code - ", GetLastError());
               else PlaySound("Ok.wav");   
            }
            else Alert("Sorry! you cannot modify your stoploss! The open price is not 'above or lower' than the entry price!");            
         }
      }
      ObjectSetInteger(0, BE_BUTTON_NAME, OBJPROP_STATE, false);
   }
}

bool priceState(string state, double openPrice)
{
   double Ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double Bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   
   if(state == "buy") return Ask > openPrice;
   if(state == "sell") return Bid < openPrice;
   
   return false;
}

void OnChartEvent(const int id, const long& lparam, const double& dparam, const string& sparam) 
{   
   OrderTypeRadioButtonItemEvent(id, sparam);
   LimitOrderTypeRadioButtonItemEvent(id, sparam);
   OrderExecutionTypeRadioButtonItemEvent(id, sparam);
   
   if (sparam == ORDER_BUTTON_NAME && id == CHARTEVENT_OBJECT_CLICK) Order(ORDER_BUTTON_NAME);
   if (sparam == ORDER_TWICE_BUTTON_NAME && id == CHARTEVENT_OBJECT_CLICK) Order(ORDER_TWICE_BUTTON_NAME);
   if (sparam == BE_BUTTON_NAME && id == CHARTEVENT_OBJECT_CLICK) ModifyTrades();
   if (sparam == DELETE_BUTTON_NAME && id == CHARTEVENT_OBJECT_CLICK) CloseTrades();
}

double PipSize(string symbol)
{
   double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
   int digits = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
   return(((digits % 2) == 1) ? point*10 : point);
}

double PipsToPrice(double pips) {
   return (pips*PipSize(_Symbol));
}

double GetLots()
{
   double lotz = 0.25;
   double lotstep = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);
   
   if (risk_percent > 0) {
      double riskAmt = AccountInfoDouble(ACCOUNT_BALANCE) * (risk_percent/100);
      lotz = NormalizeDouble(((riskAmt / ((spreadInPoints * 0.1) + stop_loss)) / PointVal()) * 0.1, 2);
   }
   // So i just found out that i made an error in my code.
   // my risk management algorithm calculated the wrong lots because of the error i made and now my profit is cut by almost half.
   // I was supposed to profit $11,000 - 11% but now my profit will be $5,306.40 - 5.3%
   // The error was cause when calculating spreads. i should have multiplied the points with 0.1
   // Always test your code before implementing it. -- That's the lesson here. Thank God that it's a demo account.
   lotz = MathFloor(lotz / lotstep) * lotstep;
   
   if (lotz < SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN)) 
   {
      lotz = 0;
      Alert("Lots traded is too small for the broker");
   }
   else if (lots > SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MAX)) 
   {
      lotz = 0;
      Alert("Lots traded is too large for the broker");
   }
      
   return lotz;
}

double PointVal() 
{
   double tickSize = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_SIZE);
   double tickValue = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE);
   double point = SymbolInfoDouble(Symbol(), SYMBOL_POINT);
   double ticksPerPt = tickSize / point;
   return tickValue / ticksPerPt;
}


double CalculateSpread(double pAsk, double pBid)
{
   double currentSpread = pAsk - pBid;
   spreadInPoints = MathRound(currentSpread / _Point);
   return currentSpread;
}