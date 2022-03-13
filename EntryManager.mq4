//+------------------------------------------------------------------+
//|                                                 EntryManager.mq4 |
//|                                                      JadeCapital |
//|                                      https://www.jadecapital.com |
//+------------------------------------------------------------------+
#property strict
#include <Controls\RadioGroup.mqh>;

string ORDER_BUTTON_NAME = "OrderButton";
double risk_percent = 0.25;
double stop_loss = 10.2; //pips need to change to stoploss
int orderTypeVal = 0;
int limitOrderTypeVal = 0;
bool radioGroup2Created = false;

CRadioGroup m_radioGroup1;
CRadioGroup m_radioGroup2;

int OnInit()
{
   //Execute("AUDUSD");
   //Execute("EURUSD");
   //Execute("USDJPY");
   //Execute("GBPJPY");
   
   //+------------------------------------------------------------------+
   //| - Risk
   //| - SL - Pips --> gets Converted to Price
   //| - Entry Price
   //| - Order Type Radio Button
   //| - Limit Order Type Radio Button
   //| - Factor in spread
   //| - Add sound wav when order is sent
   //| -                                                                   |
   //+------------------------------------------------------------------+
   
   
   GUI_Build();   
   
   return(INIT_SUCCEEDED);
}


void GUI_Build()
{   
   // Risk Text Field
   CreateLabel("risk_percent_label", 10, 20, "Risk %");
   CreateTextField("risk_percent", 140, 30, 10, 50, "0.25");
   
   // stop loss price Text Field
   CreateLabel("stop_loss_pips_label", 160, 20, "Stop Loss - Pips");
   CreateTextField("stop_loss_pips", 140, 30, 160, 50, "2.1");
   
   // entry price Text Field
   CreateLabel("entry_price_label", 10, 90, "Entry Price");
   CreateTextField("entry_price", 300, 30, 10, 120, "0.00001");
   
   // order type radio button
   CreateLabel("order_type_label", 10, 160, "Order Type");
   string radio_buttons[2] = {"Market Execution", "Limit Order"};
   int labelxsize[2] = {40, 40};
   int labelysize[2] = {190, 210};
   int buttonxsize[2] = {20, 20};
   int buttonysize[2] = {190, 210};
   CreateRadioGroup(m_radioGroup1, radio_buttons, 2, "OrderType", labelxsize, labelysize, buttonxsize, buttonysize);
   
   // Order Button
   CreatePlaceOrderButton();
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
   CreateRadioGroup(m_radioGroup2, lot_radio_buttons, 4, "LimitOrderType", labelxsize, labelysize, buttonxsize, buttonysize);
}

void OnDeinit(const int reason)
{
   m_radioGroup1.Destroy();
   m_radioGroup2.Destroy();
}


void OnTick()
{

   
}

bool CreateRadioGroup(CRadioGroup& radioGroup, string& radio_buttons[], int count, string group_name, int& labelxsize[],
   int& labelysize[],
   int& buttonxsize[],
   int& buttonysize[])
{
   radioGroup.Create(0, group_name, 0, 20, 20, 300, 100);   
   RadioGroupPositioning(count, group_name, labelxsize, labelysize, buttonxsize, buttonysize);
   
   for(int i=0; i < count; i++)
      if(!radioGroup.AddItem(radio_buttons[i], i)) return(false);

   radioGroup.Value(0);
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

void CreatePlaceOrderButton()
{
   ObjectCreate(0, ORDER_BUTTON_NAME, OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, ORDER_BUTTON_NAME, OBJPROP_XSIZE, 300);
   ObjectSetInteger(0, ORDER_BUTTON_NAME, OBJPROP_YSIZE, 50);
   ObjectSetInteger(0, ORDER_BUTTON_NAME, OBJPROP_XDISTANCE, 10);
   ObjectSetInteger(0, ORDER_BUTTON_NAME, OBJPROP_YDISTANCE, 250);
   ObjectSetInteger(0, ORDER_BUTTON_NAME, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, ORDER_BUTTON_NAME, OBJPROP_BGCOLOR, clrGreen);
   
   ObjectSetString(0, ORDER_BUTTON_NAME, OBJPROP_TEXT, "Place Order");
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
            
            type == "OrderType" ? orderTypeVal = i : limitOrderTypeVal = i;
            
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

void OrderTypeRadioButtonItemEvent(int id, string sparam)
{
   string item[2] = {"OrderTypeItem0Button", "OrderTypeItem1Button"};
   RadioButtonOnChangeEvent(id, sparam, 2, item, "OrderType");
   
   if(orderTypeVal == 1 && !radioGroup2Created) 
   {
      CreateLimitOrderTypeRadio();
      radioGroup2Created = true;
      ObjectSetInteger(0, ORDER_BUTTON_NAME, OBJPROP_YDISTANCE, 360);
      ObjectSetString(0, "limit_order_type_label", OBJPROP_TEXT, "Limit Order Type");
   }
   else if (orderTypeVal != 1 && radioGroup2Created) 
   {
      ObjectSetInteger(0, ORDER_BUTTON_NAME, OBJPROP_YDISTANCE, 250);
      ObjectSetString(0, "limit_order_type_label", OBJPROP_TEXT, "");
      radioGroup2Created = false;
      m_radioGroup2.Destroy();
   }
   
   //PrintFormat("Order Type Value: %i & Radio 2 created: %i", orderTypeVal, radioGroup2Created);
}

void LimitOrderTypeRadioButtonItemEvent(int id, string sparam)
{
   string item[4] = {"LimitOrderTypeItem0Button", "LimitOrderTypeItem1Button", "LimitOrderTypeItem2Button", "LimitOrderTypeItem3Button"};
   RadioButtonOnChangeEvent(id, sparam, 4, item, "LimitOrderType");
}

void OnChartEvent(const int id, const long& lparam, const double& dparam, const string& sparam) 
{   
   //Print("id: ", id, "lparam: ", lparam, "sparam", sparam);

   OrderTypeRadioButtonItemEvent(id, sparam);
   LimitOrderTypeRadioButtonItemEvent(id, sparam);
      
   if (sparam == ORDER_BUTTON_NAME) 
   {
      string risk_percent_string = ObjectGetString(0, "risk_percent", OBJPROP_TEXT);
      risk_percent = StringToDouble(risk_percent_string);
      
      string stop_loss_string = ObjectGetString(0, "stop_loss_pips", OBJPROP_TEXT);
      stop_loss = StringToDouble(stop_loss_string);
   
      //set a timer here to slow the change in setting the object click and unclick state
      Sleep(30);
      
      Print("risk percent: ", risk_percent);
      ObjectSetInteger(0, ORDER_BUTTON_NAME, OBJPROP_STATE, false);
   }
}

void Execute(string symbol) 
{
   PrintFormat("Base Currency is %s", AccountCurrency());
   PrintFormat("Testing for symbol %s", symbol);
   double ptValue = PointVal(symbol);
   PrintFormat("ValuePerPoint for %s is %f", symbol, ptValue);
   
   
   GetLots(symbol);
   
}

double ConvertStopLossPoints() {
   return 0;
}

double GetLots(string symbol)
{
   double lots = 0.5;
   
   if (risk_percent > 0) {
      // Fixed risk amt & SL, how many lots to trade?
      double riskAmt = AccountEquity() * (risk_percent/100);
      lots = (riskAmt / stop_loss) / PointVal(symbol);
      PrintFormat("Risk lots for %s value %f and SL at %f point is %f", symbol, riskAmt, stop_loss, lots);
   }
   
   if (lots < MarketInfo(Symbol(), MODE_MINLOT)) 
   {
      lots = 0;
      Alert("Lots traded is too small for your the broker");
   }
   else if (lots > MarketInfo(Symbol(), MODE_MAXLOT)) 
   {
      lots = 0;
      Alert("Lots traded is too large for your the broker");
   }
      
   return lots;
}

//---
// Calculate the value in base currecny
// of a one pt move in the price
// of the supplied currency for one lot

double PointVal(string symbol) 
{
   double tickSize = MarketInfo(Symbol(), MODE_TICKSIZE);
   double tickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
   double point = MarketInfo(Symbol(), MODE_POINT);
   double ticksPerPt = tickSize / point;
   double ptValue = tickValue / ticksPerPt;
   
   PrintFormat("ticksize=%f, tickValue=%f, point=%f, tickPerPoint=%f, ptValue", tickSize, tickValue, point, ticksPerPt, ptValue);
   return ptValue;
}


double CalculateSpread(double pAsk, double pBid, string symbol)
{
   double currentSpread = pAsk - pBid;
   return currentSpread / _Point;
}