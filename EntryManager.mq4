//+------------------------------------------------------------------+
//|                                                 EntryManager.mq4 |
//|                                                      JadeCapital |
//|                                      https://www.jadecapital.com |
//+------------------------------------------------------------------+
#property strict
#include <Controls\RadioGroup.mqh>;
#include <Controls\Button.mqh>;

string ORDER_BUTTON_NAME = "OrderButton";
double risk_percent = 0.22;
double stop_loss = 10.2; //pips need to change to stoploss
double entry_price = 0.00001;
double spreadInPoints = 0;

int orderTypeVal = 0;
int limitOrderTypeVal = 0;
int orderExecTypeVal = 0;

bool radioGroup2Created = false;
bool radioGroup3Created = false;

CRadioGroup m_radioGroup1;
CRadioGroup m_radioGroup2;
CRadioGroup m_radioGroup3;
CButton placeOrderButton;

int ticket = 0;
string ticketType = "instant_buy";

int OnInit()
{   
   GUI_Build();
   return(INIT_SUCCEEDED);
}


void GUI_Build()
{  
   // Risk Text Field
   CreateLabel("risk_percent_label", 10, 20, "Risk % (*)");
   CreateTextField("risk_percent", 140, 30, 10, 50, "0.22");
   
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
   CreateRadioGroup(m_radioGroup1, radio_buttons, 2, "OrderType", labelxsize, labelysize, buttonxsize, buttonysize);
  
   
   CreateOrderExecutionRadioButton();
   
   ReorderRadioButtonsOnChange(0);
   DestroyEntryPriceTextField();
   
   // Order Button
   CreatePlaceOrderButton();
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
   CreateRadioGroup(m_radioGroup2, lot_radio_buttons, 4, "LimitOrderType", labelxsize, labelysize, buttonxsize, buttonysize);
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
   CreateRadioGroup(m_radioGroup3, _radio_buttons, 2, "OrderExecutionType", labelxsize, labelysize, buttonxsize, buttonysize);
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

void CreatePlaceOrderButton()
{
   placeOrderButton.Create(0,ORDER_BUTTON_NAME,0,10,0,300,50);
   placeOrderButton.Text("Place Order");
   placeOrderButton.FontSize(10);
   placeOrderButton.Color(clrWhite);
   placeOrderButton.ColorBackground(clrGreen);
   ObjectSetInteger(0, ORDER_BUTTON_NAME, OBJPROP_XDISTANCE, 10);
   ObjectSetInteger(0, ORDER_BUTTON_NAME, OBJPROP_YDISTANCE, 300);
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
   }
   
   else if (orderTypeVal == 0 && radioGroup2Created && !radioGroup3Created) 
   {
      CreateOrderExecutionRadioButton();
      ReorderRadioButtonsOnChange(0);
   
      ObjectDelete(0, "limit_order_type_label");
      ObjectSetInteger(0, ORDER_BUTTON_NAME, OBJPROP_YDISTANCE, 320);
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

void onClick()
{
   if (bool(ObjectGetInteger(0, ORDER_BUTTON_NAME, OBJPROP_STATE)))
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
      
      double spread = CalculateSpread(Ask, Bid);
      double lots = GetLots();
      double stoploss = orderTypeVal == 0 && radioGroup3Created ? 
                        orderExecTypeVal == 0 ? 
                        Ask - PipsToPrice(stop_loss) : 
                        Bid + PipsToPrice(stop_loss) + spread : 
                        limitOrderTypeVal == 0 || limitOrderTypeVal == 2 ? 
                        entry_price - PipsToPrice(stop_loss) :
                        entry_price + (PipsToPrice(stop_loss) + spread);
                        
      double entryPlusSpread = entry_price + spread;
                        

      if (orderTypeVal == 0 && radioGroup3Created) 
      {
         ticket = OrderSend(_Symbol, orderExecTypeVal == 0 ? OP_BUY : OP_SELL, lots, orderExecTypeVal == 0 ? Ask : Bid, 2, stoploss, 0, "", 3238, 0, clrTeal);
      }      
      if (orderTypeVal == 1 && radioGroup2Created)
      {
         ticket = OrderSend(_Symbol, limitOrderTypeVal == 0 ? 
            OP_BUYSTOP : limitOrderTypeVal == 1 ? 
            OP_SELLSTOP : limitOrderTypeVal == 2 ? 
            OP_BUYLIMIT : limitOrderTypeVal == 3 ? 
            OP_SELLLIMIT : NULL, lots, 
            limitOrderTypeVal == 0 || limitOrderTypeVal == 2 ? 
            entryPlusSpread : entry_price, 2, stoploss, 0, "", 3238, 0, clrTeal);
      }
      
      if(ticket == -1) {
         PlaySound("timeout.wav");
         Alert("An error has occured: Error-" + IntegerToString(GetLastError()));
      }
      else PlaySound("Ok.wav");
      
      ObjectSetInteger(0, ORDER_BUTTON_NAME, OBJPROP_STATE, false);
   }
}

void OnChartEvent(const int id, const long& lparam, const double& dparam, const string& sparam) 
{   
   OrderTypeRadioButtonItemEvent(id, sparam);
   LimitOrderTypeRadioButtonItemEvent(id, sparam);
   OrderExecutionTypeRadioButtonItemEvent(id, sparam);
   
   if (sparam == ORDER_BUTTON_NAME && id == CHARTEVENT_OBJECT_CLICK)
   {
      onClick();
   }
}

double PipSize(string symbol)
{
   double point = MarketInfo(symbol, MODE_POINT);
   int digits = (int)MarketInfo(symbol, MODE_DIGITS);
   return(((digits % 2) == 1) ? point*10 : point);
}

double PipsToPrice(double pips) {
   return (pips*PipSize(_Symbol));
}

double GetLots()
{
   double lots = 0.25;
   
   if (risk_percent > 0) {
      double riskAmt = AccountBalance() * (risk_percent/100);
      lots = NormalizeDouble(((riskAmt / (spreadInPoints + stop_loss)) / PointVal()) * 0.1, 2);
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

double PointVal() 
{
   double tickSize = MarketInfo(Symbol(), MODE_TICKSIZE);
   double tickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
   double point = MarketInfo(Symbol(), MODE_POINT);
   double ticksPerPt = tickSize / point;
   return tickValue / ticksPerPt;
}


double CalculateSpread(double pAsk, double pBid)
{
   PrintFormat("Ask: %f & Bid: %f", pAsk, pBid);
   double currentSpread = pAsk - pBid;
   spreadInPoints = MathRound(currentSpread / _Point);
   return currentSpread;
}