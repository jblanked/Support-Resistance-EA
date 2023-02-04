//+------------------------------------------------------------------+
//|                                    Support and Resistance EA.mq4 |
//|                                          Copyright 2023,JBlanked |
//|                                         https://www.jblanked.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023,JBlanked"
#property link      "https://www.jblanked.com"
#property strict

#include <CustomFunctionsFix.mqh>


input    string         orderSeng         = "======= ORDER SETTINGS ======";  //--------------------------->
input    double         StopLoss          = 10; // Stop Loss
input    double         TakeProfit        = 600; // Take Profit
input    bool           usepercentrisk    = true; // Use risk per trade?
input    double         percentrisk       = 0.10; // Percent risk
input    bool           uselotsize        = false; // Use lot size?
input    double         lotsizee          = 0.10; // Lot size

input    string         orderSeting       = "======= TREND SETTINGS ======";  //--------------------------->
input    int            MA_Period         = 160; // Period for moving average
input    int            RSI_Period        = 8; // Period for RSI
input    int            rsibuylevel       = 20; // RSI under which level to buy
input    int            rsiselllevel      = 80; // RSI above which level to sell
input    bool           reverseorder      = false; // Reverse trend?
input    bool           HODL              = false; // HODL til opposite setup?


input    string         BreakEvenSettings = "--------TAKE PARTIAL SETTINGS-------";  //--------------------------->
input    bool           UseBreakEvenStop  = true;  //Use take partials?
input    double         BEclosePercent    = 50.0;   //Close how much percent?
input    double         breakstart        = 200; // Take partials after how many pips in profit (1)
input    double         breakstart2       = 300; // Take partials after how many pips in profit (2)
input    double         breakstart3       = 400; // Take partials after how many pips in profit (3)
input    double         breakstart4       = 500; // Take partials after how many pips in profit (4)

input    double         breakstop         = 20; // Move stop loss in profit X pips  

input    string         BkEvnSettings     = "======= MARTINGALE SETTINGS =======";  //--------------------------->
input    bool           useMartingale     = false; // Use martingale?
input    double         martinPips        = 78; // Pips in between martingales
input    double         martinMULTI       = 5; // Martingale multiplier


input    string         timeSettings      = "======= TIME SETTINGS ======";  //--------------------
input    bool           UseTimer          = false;    // Custom trading hours (true/false)
input    string         StartTime1        = "16:30";  //1 Trading start time (hh:mm)
input    string         StopTime1         = "16:31";  //1 Trading stop time (hh:mm)

input    string         DAILY_TARGETS     = "======= Gain/Loss =======";  //---------------
input    double         dailyTargetP      = 10.0;        // Daily Profit Target (%)
input    double         dailyLossP        = 0.4;        // Daily Max DD (%)


input    string         orderSettins      = "======= OTHER SETTINGS ======";    //---------------
input    string         orderComments     = "Support/Resistance EA"; // Order Comment
input    int            magicnumb         = 918119; // Magic Number


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

JBlankedInitCEO(magicnumb,918119,"Support/Resistance EA");
JBlankedBranding("Support/Resistance EA",magicnumb,string(expiryDateVIP));
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   JBlankedDeinit();

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

if(ApplyDailyTarget(dailyTargetP,dailyLossP,magicnumb)) return;

if(useMartingale) { martingale(_Symbol,magicnumb,OrderStopLoss(),martinMULTI,martinPips); }

//////////////////// Start Take Partials Tempalte

if(UseBreakEvenStop)DoBreak2(magicnumb,breakstart,BEclosePercent,breakstop,breakstart2,breakstart3,breakstart4);



//////////////////// End Take Partials Tempalte


   
  
//+------------------------------------------------------------------+


    double MA = iMA(NULL,0,MA_Period,0,MODE_SMA,PRICE_CLOSE,0);
    double RSI = iRSI(NULL,0,RSI_Period,PRICE_CLOSE,0);
    double currentPrice = Close[0];

   if(allowTime(UseTimer,StartTime1,StopTime1))
   {
   if(!CheckIfOpenOrdersByMagicNB(magicnumb,orderComments) && StopLoss != 0 && !HODL)
   {
   if(!reverseorder)
   {
    if (currentPrice > MA && RSI < rsibuylevel) 
    {
        //price is above moving average and RSI is below 30, indicating oversold
        //enter long position
      int orderr=  OrderSend(Symbol(),OP_BUY,GetRisk(usepercentrisk,uselotsize,percentrisk,StopLoss,lotsizee),Ask,3,Ask-StopLoss*GetPipValue(),Ask+TakeProfit*GetPipValue(),orderComments,magicnumb,0,Green);
           
    } 

    
    else if (currentPrice < MA && RSI > rsiselllevel) 
    {
        //price is below moving average and RSI is above 70, indicating overbought
        //enter short position
      int orderr=   OrderSend(Symbol(),OP_SELL,GetRisk(usepercentrisk,uselotsize,percentrisk,StopLoss,lotsizee),Bid,3,Bid+StopLoss*GetPipValue(),Bid-TakeProfit*GetPipValue(),orderComments,magicnumb,0,Red);
     
    }
      }
      
   
     if(reverseorder)
   {
    if (currentPrice > MA && RSI < rsibuylevel) 
    {
        //price is above moving average and RSI is below 30, indicating oversold
        //enter long position
       int orderr=   OrderSend(Symbol(),OP_SELL,GetRisk(usepercentrisk,uselotsize,percentrisk,StopLoss,lotsizee),Bid,3,Bid+StopLoss*GetPipValue(),Bid-TakeProfit*GetPipValue(),orderComments,magicnumb,0,Red);
          
    } 

    
    else if (currentPrice < MA && RSI > rsiselllevel) 
    {
        //price is below moving average and RSI is above 70, indicating overbought
        //enter short position
         int orderr=  OrderSend(Symbol(),OP_BUY,GetRisk(usepercentrisk,uselotsize,percentrisk,StopLoss,lotsizee),Ask,3,Ask-StopLoss*GetPipValue(),Ask+TakeProfit*GetPipValue(),orderComments,magicnumb,0,Green);
 
     
    }
   } 
   } 
   
   
    if(!CheckIfOpenOrdersByMagicNB(magicnumb,orderComments) && StopLoss == 0)
   {
   if(!reverseorder)
   {
    if (currentPrice > MA && RSI < rsibuylevel) 
    {
        //price is above moving average and RSI is below 30, indicating oversold
        //enter long position
      int orderr=  OrderSend(Symbol(),OP_BUY,GetRisk(usepercentrisk,uselotsize,percentrisk,StopLoss,lotsizee),Ask,3,0,Ask+TakeProfit*GetPipValue(),orderComments,magicnumb,0,Green);
           
    } 

    
    else if (currentPrice < MA && RSI > rsiselllevel) 
    {
        //price is below moving average and RSI is above 70, indicating overbought
        //enter short position
      int orderr=   OrderSend(Symbol(),OP_SELL,GetRisk(usepercentrisk,uselotsize,percentrisk,StopLoss,lotsizee),Bid,3,0,Bid-TakeProfit*GetPipValue(),orderComments,magicnumb,0,Red);
     
    }
      }
         
      
     if(reverseorder)
   {
    if (currentPrice > MA && RSI < rsibuylevel) 
    {
        //price is above moving average and RSI is below 30, indicating oversold
        //enter long position
       int orderr=   OrderSend(Symbol(),OP_SELL,GetRisk(usepercentrisk,uselotsize,percentrisk,StopLoss,lotsizee),Bid,3,0,Bid-TakeProfit*GetPipValue(),orderComments,magicnumb,0,Red);
          
    } 

    
    else if (currentPrice < MA && RSI > rsiselllevel) 
    {
        //price is below moving average and RSI is above 70, indicating overbought
        //enter short position
         int orderr=  OrderSend(Symbol(),OP_BUY,GetRisk(usepercentrisk,uselotsize,percentrisk,StopLoss,lotsizee),Ask,3,0,Ask+TakeProfit*GetPipValue(),orderComments,magicnumb,0,Green);
 
     
    }
   } 
   }   
   
   
   
   
   
  
  
  
  
  
  
  
  
  
  
  
  
  
   if(!CheckIfOpenOrdersByMagicNB(magicnumb,orderComments) && StopLoss != 0 && HODL)
   {
   if(!reverseorder)
   {
    if (currentPrice > MA && RSI < rsibuylevel) 
    {
        //price is above moving average and RSI is below 30, indicating oversold
        //enter long position
      int orderr=  OrderSend(Symbol(),OP_BUY,GetRisk(usepercentrisk,uselotsize,percentrisk,StopLoss,lotsizee),Ask,3,Ask-StopLoss*GetPipValue(),0,orderComments,magicnumb,0,Green);
           
    } 

    
    else if (currentPrice < MA && RSI > rsiselllevel) 
    {
        //price is below moving average and RSI is above 70, indicating overbought
        //enter short position
      int orderr=   OrderSend(Symbol(),OP_SELL,GetRisk(usepercentrisk,uselotsize,percentrisk,StopLoss,lotsizee),Bid,3,Bid+StopLoss*GetPipValue(),0,orderComments,magicnumb,0,Red);
     
    }
      }
      
   
     if(reverseorder)
   {
    if (currentPrice > MA && RSI < rsibuylevel) 
    {
        //price is above moving average and RSI is below 30, indicating oversold
        //enter long position
       int orderr=   OrderSend(Symbol(),OP_SELL,GetRisk(usepercentrisk,uselotsize,percentrisk,StopLoss,lotsizee),Bid,3,Bid+StopLoss*GetPipValue(),0,orderComments,magicnumb,0,Red);
          
    } 

    
    else if (currentPrice < MA && RSI > rsiselllevel) 
    {
        //price is below moving average and RSI is above 70, indicating overbought
        //enter short position
         int orderr=  OrderSend(Symbol(),OP_BUY,GetRisk(usepercentrisk,uselotsize,percentrisk,StopLoss,lotsizee),Ask,3,Ask-StopLoss*GetPipValue(),0,orderComments,magicnumb,0,Green);
 
     
    }
   } 
   } 
   
   
    if(!CheckIfOpenOrdersByMagicNB(magicnumb,orderComments) && StopLoss == 0)
   {
   if(!reverseorder)
   {
    if (currentPrice > MA && RSI < rsibuylevel) 
    {
        //price is above moving average and RSI is below 30, indicating oversold
        //enter long position
      int orderr=  OrderSend(Symbol(),OP_BUY,GetRisk(usepercentrisk,uselotsize,percentrisk,StopLoss,lotsizee),Ask,3,0,0,orderComments,magicnumb,0,Green);
           
    } 

    
    else if (currentPrice < MA && RSI > rsiselllevel) 
    {
        //price is below moving average and RSI is above 70, indicating overbought
        //enter short position
      int orderr=   OrderSend(Symbol(),OP_SELL,GetRisk(usepercentrisk,uselotsize,percentrisk,StopLoss,lotsizee),Bid,3,0,0,orderComments,magicnumb,0,Red);
     
    }
      }
         
      
     if(reverseorder)
   {
    if (currentPrice > MA && RSI < rsibuylevel) 
    {
        //price is above moving average and RSI is below 30, indicating oversold
        //enter long position
       int orderr=   OrderSend(Symbol(),OP_SELL,GetRisk(usepercentrisk,uselotsize,percentrisk,StopLoss,lotsizee),Bid,3,0,0,orderComments,magicnumb,0,Red);
          
    } 

    
    else if (currentPrice < MA && RSI > rsiselllevel) 
    {
        //price is below moving average and RSI is above 70, indicating overbought
        //enter short position
         int orderr=  OrderSend(Symbol(),OP_BUY,GetRisk(usepercentrisk,uselotsize,percentrisk,StopLoss,lotsizee),Ask,3,0,0,orderComments,magicnumb,0,Green);
 
     
    }
   } 
   }    
   
   
   }
   
      
}
