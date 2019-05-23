//
//  TPHTTPRoutes.h
//  TachPay
//
//  Created by Yaroslav Bulda on 3/28/15.
//  Copyright (c) 2015 tachcard. All rights reserved.
//

#define addRoute(name, path) static NSString *const name = path

addRoute(TCCHTTPRequestRegisterRoute, @"/register");
addRoute(TCCHTTPRequestRegisterCheckCode, @"/register/check-code");
addRoute(TCCHTTPRequestRegisterResendCode, @"/register/resend-code");
addRoute(TCCHTTPRequestMasterpassGetConfig, @"/masterpass/get-config");

addRoute(TCCHTTPRequestMasterpassToken, @"/masterpass/token");
addRoute(TCCHTTPRequestTransactionsInit, @"/transactions/init");
addRoute(TCCHTTPRequestTransactionsConfirm, @"/transactions/confirm");


addRoute(TCCHTTPRequestUserLeaveComment, @"/user/leave-comment");

addRoute(TCCHTTPRequestTicketsView, @"/tickets/view");
addRoute(TCCHTTPRequestTicketsList, @"/tickets/list");
addRoute(TCCHTTPRequestTicketsHistory, @"/tickets/history");
addRoute(TCCHTTPRequestTicketsService, @"/tickets/service");

addRoute(TCCHTTPRequestTicketsStats, @"/tickets/stats");




addRoute(TCCHTTPRequestRegisterConfirmRoute, @"/register/confirm");
addRoute(TCCHTTPRequestRenewPushTokenRoute, @"/register/renewpushtoken");
addRoute(TCCHTTPRequestUserInfoRoute, @"/register/userinfo");

addRoute(TCCHTTPRequestCheckeMailRoute, @"/register/checkemail");

addRoute(TCCHTTPRequestFeedbackRoute, @"/addopinion");

addRoute(TCCHTTPRequestTransactionsRoute, @"/transactions");
//addRoute(TCCHTTPRequestTransactionsCancelRoute, @"transactions/cancel");
addRoute(TCCHTTPRequestTransactionsSwitchRoute, @"transactions/swiErrortch");

addRoute(TCCHTTPRequestWalletRoute, @"/account");

addRoute(TCCHTTPRequestCreateInvoiceRoute, @"/receipt/create");
addRoute(TCCHTTPRequestCancelInvoiceRoute, @"receipt/cancel");
//addRoute(TCCHTTPRequestSendInvoiceRoute, @"/receipt/send");
//addRoute(TCCHTTPRequestSendConfirmInvoiceRoute, @"receipt/send/confirm");
addRoute(TCCHTTPRequestViewInvoiceRoute, @"/receipt/view");

addRoute(TCCHTTPRequestPayInvoiceRoute, @"/pay");
addRoute(TCCHTTPRequestPayConfirmRoute, @"/pay/confirm");
addRoute(TCCHTTPRequestPayLongpullRoute, @"/lp");

//Card
addRoute(TCCHTTPRequestAddCreditCardRoute, @"/taslink/bind");
addRoute(TCCHTTPRequestAddCreditCardConfirmRoute, @"/taslink/view");

//Webmoney
addRoute(TCCHTTPRequestWMAddUWallletRoute, @"/webmoney/bind");
addRoute(TCCHTTPRequestWMConfirmWallletRoute, @"webmoney/bind/confirm");

//Transfer
addRoute(TCCHTTPRequestTransferRatesRoute, @"/transfer");
addRoute(TCCHTTPRequestTransferCalcRoute, @"/transfer/calc");
addRoute(TCCHTTPRequestTransferConfirmRoute, @"/transfer/confirm");

//Exchange
addRoute(TCCHTTPRequestExchangeRoute, @"/exchange");
addRoute(TCCHTTPRequestExchangeConfirm, @"/exchange/confirm");

//Security Pin
addRoute(TCCHTTPRequestSavePinRoute, @"/auth/savepin");
addRoute(TCCHTTPRequestCheckPinRoute, @"/auth/checkpin");

//Сhanges
addRoute(TCCHTTPRequestChangesRoute, @"/changes");

//Restore
addRoute(TCCHTTPRequestRestoreRoute, @"/auth/restore");
addRoute(TCCHTTPRequestRestoreConfirmRoute, @"/auth/restore/confirm");
addRoute(TCCHTTPRequestRestoreCompleteRoute, @"/auth/restore/complete");

//Address

addRoute(TCCHTTPRequestAddressRoute, @"/address");

//Сontacts
addRoute(TCCHTTPRequestContactsRoute, @"/contacts");

addRoute(TCCHTTPRequestC2ctransferCalcRoute, @"/c2ctransfer/calc");
addRoute(TCCHTTPRequestC2ctransferRoute, @"c2ctransfer");
addRoute(TCCHTTPRequestC2ctransferConfirmRoute, @"/c2ctransfer/confirm");

addRoute(TCCHTTPRequestC2cReceiversConfirmRoute, @"/c2c/receivers");

addRoute(TCCHTTPRequestAuthsRoute, @"auths");
addRoute(TCCHTTPRequestAuthRoute, @"auth");



addRoute(TCCHTTPRequestAccountsPriority, @"/accounts-priority");


addRoute(TCCHTTPRequestMasterpassConfig, @"/masterpass/config");
addRoute(TCCHTTPRequestMasterpassMakeAccount, @"/masterpass/make/account");
addRoute(TCCHTTPRequestMasterpassInit, @"/masterpass/init");
addRoute(TCCHTTPRequestMasterpassCommit, @"/masterpass/commit");


addRoute(TCCHTTPRequestPhoenixCategoriesInfo, @"/phoenix/categories/info");
addRoute(TCCHTTPRequestPhoenixCategories, @"/phoenix/categories");
addRoute(TCCHTTPRequestPhoenixOptions, @"/phoenix/options");

addRoute(TCCHTTPRequestPhoenixAddToTemplates, @"/phoenix/add-to-templates");
addRoute(TCCHTTPRequestPhoenixRemoveTemplate, @"/phoenix/remove-template");
addRoute(TCCHTTPRequestPhoenixFindTemplate, @"/phoenix/find-template");

addRoute(TCCHTTPRequestIbeaconReceipt, @"/i-beacon/receipt");
addRoute(TCCHTTPRequestIbeaconUuid, @"/i-beacon/uuid");


addRoute(TCCHTTPRequestRegisterGetQuestion, @"/register/questions");
addRoute(TCCHTTPRequestRegisterCheckQuestion, @"/register/check-question");
addRoute(TCCHTTPRequestRegisterEditQuestion, @"/register/edit-question");
addRoute(TCCHTTPRequestRegisterCreateQuestion, @"/register/create-question");
addRoute(TCCHTTPRequestAuthRestoreCheckAnswer, @"/auth/restore/check-answer");

addRoute(TCCHTTPRequestP2pAccount, @"/p2p-app/account");
addRoute(TCCHTTPRequestP2pInit, @"/p2p-app/init");
addRoute(TCCHTTPRequestP2pPrepare, @"/p2p-app/prepare");
addRoute(TCCHTTPRequestP2pCheckTransaction, @"/p2p-app/check-transaction");
addRoute(TCCHTTPRequestP2pCheckLookup, @"/p2p-app/check-lookup");
addRoute(TCCHTTPRequestP2pUpdateInfo, @"/p2p-app/update-info");

addRoute(TCCHTTPRequestFCardAccount, @"/f-card/account");
addRoute(TCCHTTPRequestFCardInit, @"/f-card/init");
addRoute(TCCHTTPRequestFCardPrepare, @"/f-card/prepare");



addRoute(TCCHTTPRequestSystemRegister, @"/system-register");

addRoute(TCCHTTPRequestMagicReceipt, @"/magic/receipt");
addRoute(TCCHTTPRequestMagicInit, @"/magic/init");
addRoute(TCCHTTPRequestMagicPrepare, @"/magic/prepare");
addRoute(TCCHTTPRequestMagicCheckLookup, @"/magic/check-lookup");

addRoute(TCCHTTPRequestMasterpassGetQrAccount, @"/masterpass/get-qr-account");

addRoute(TCCHTTPRequestMasterpassGetTlvToken, @"/masterpass/tlv-token");



