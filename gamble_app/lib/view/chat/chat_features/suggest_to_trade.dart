// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:go_router/go_router.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:toggle_switch/toggle_switch.dart';
// import 'package:trading_trads/states/chats/tradeSuggest.dart';
// import 'package:trading_trads/states/userstate.dart';
// import 'package:trading_trads/states/watchllist/stockdata.dart';
// import 'package:trading_trads/utils/alerts.dart';
// import 'package:trading_trads/utils/custom_types.dart';

// class SuggestTrade extends HookConsumerWidget {
//   final int roomId;
//   const SuggestTrade({super.key, required this.roomId});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     ValueNotifier<int> optionIndex = useState(0);
//     ValueNotifier<int> userId = useState(0);
//     ValueNotifier<double> stockPrice = useState(0.0);
//     ValueNotifier<List> stocks = useState([]);
//     ValueNotifier<Suggestion> selectedStock =
//         useState(Suggestion(symbol: "", id: 0, exchange: "", price: ""));

//     TextEditingController stockController = useTextEditingController();
//     TextEditingController qtyController = useTextEditingController();
//     TextEditingController buyTargetController = useTextEditingController();
//     TextEditingController sellTargetController = useTextEditingController();
//     TextEditingController descriptionController = useTextEditingController();

//     var stockBuyOptions = ['CE', 'PUT'];
//     final stockDataW = ref.watch(stockDataState);
//     final userW = ref.watch(userState);
//     final tradeSuggestiontW = ref.watch(tradeSuggestionState);

//     Future<void> init() async {
//       if (!context.mounted) return;
//       // List data = await stockDataW.getAllStocks(context);
//       userId.value = await userW.getUserData(UserData.id, context);
//       stocks.value = stockDataW.stocksData;
//     }

//     List<Suggestion> showSuggestion(input) {
//       List<Suggestion> suggestions = [];
//       for (var stock in stocks.value) {
//         if (stock["symbol"].toLowerCase().contains(input.toLowerCase())) {
//           suggestions.add(Suggestion(
//               id: int.parse(stock["id"].toString()),
//               symbol: stock["symbol"],
//               exchange: stock["exchange"] ?? 'NSE',
//               price: "234.34"));
//         }
//       }
//       return suggestions;
//     }

//     useEffect(() {
//       init();
//       return null;
//     }, const []);

//     return Scaffold(
//         backgroundColor: const Color.fromARGB(255, 242, 244, 251),
//         appBar: AppBar(
//           backgroundColor: const Color.fromARGB(255, 242, 244, 251),
//           leading: IconButton(
//             onPressed: () => context.pop(),
//             icon: const Icon(Icons.arrow_back),
//           ),
//           centerTitle: true,
//           title: const Text(
//             "Create Suggestion",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 5),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // ............................ Search for stock ............................ //
//                 Container(
//                   margin:
//                       const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
//                   padding: const EdgeInsets.all(15),
//                   width: double.maxFinite,
//                   // height: 190,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Colors.white,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),
//                         spreadRadius: 0.5,
//                         blurRadius: 1.0,
//                         offset: const Offset(0, 0.5),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       // ..... Headphone ....
//                       const Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Stocks',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 13,
//                                 color: Color.fromARGB(195, 41, 41, 41)),
//                           ),
//                           Text(
//                             'Market Price',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 13,
//                                 color: Color.fromARGB(195, 41, 41, 41)),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),

//                       // ..... Stock Search field ....
//                       SizedBox(
//                         height: 50,
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: TypeAheadField(
//                                 direction: VerticalDirection.down,
//                                 controller: stockController,
//                                 onSelected: (selected) {
//                                   stockController.text = selected.symbol;
//                                   selectedStock.value = selected;
//                                 },
//                                 suggestionsCallback: (input) =>
//                                     showSuggestion(input),
//                                 itemBuilder: (context, product) => ListTile(
//                                     title: Text(product.symbol),
//                                     subtitle: Text(
//                                       '${product.exchange} - \$${product.price}',
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     )),
//                                 // builder: (context, invalid, node) =>
//                                 //     TextFormField(
//                                 //   controller: stockController,
//                                 //   autofocus: true,
//                                 //   enableSuggestions: false,
//                                 //   textAlignVertical: TextAlignVertical.center,
//                                 //   decoration: InputDecoration(
//                                 //     hintText: "Select & Search",
//                                 //     hintStyle: const TextStyle(fontSize: 13),
//                                 //     contentPadding:
//                                 //         const EdgeInsets.only(top: 10),
//                                 //     prefixIcon: Padding(
//                                 //       padding: const EdgeInsets.only(
//                                 //           top: 3.0, right: 0),
//                                 //       child: Image.asset(
//                                 //         'assets/icons/search.png',
//                                 //         color:
//                                 //             const Color.fromARGB(255, 97, 93, 93),
//                                 //         scale: 3.3,
//                                 //       ),
//                                 //     ),
//                                 //     suffixIcon: Padding(
//                                 //       padding: const EdgeInsets.only(
//                                 //           top: 2.0, right: 9),
//                                 //       child: InkWell(
//                                 //         onTap: () => stockController.text = "",
//                                 //         child: const Icon(
//                                 //           Icons.close,
//                                 //           size: 18,
//                                 //           color: Colors.black54,
//                                 //         ),
//                                 //       ),
//                                 //     ),
//                                 //     enabledBorder: OutlineInputBorder(
//                                 //       borderRadius: BorderRadius.circular(8),
//                                 //       borderSide: const BorderSide(
//                                 //           width: 0.5,
//                                 //           color: Color.fromARGB(52, 0, 0, 0)),
//                                 //     ),
//                                 //     focusedBorder: OutlineInputBorder(
//                                 //       borderRadius: BorderRadius.circular(8),
//                                 //       borderSide: const BorderSide(
//                                 //           width: 1, color: Colors.grey),
//                                 //     ),
//                                 //   ),
//                                 // ),
//                               ),
//                             ),
//                             Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 12.0),
//                               child: Center(
//                                 child: Text(
//                                   stockPrice.value.toString(),
//                                   textAlign: TextAlign.center,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 16),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 25,
//                       ),
//                       const Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Stock Name / Exe. price',
//                               style: TextStyle(
//                                   letterSpacing: -0.3,
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 12.1,
//                                   color: Color.fromARGB(195, 41, 41, 41)),
//                             ),
//                             Text(
//                               'OPT / LTP',
//                               style: TextStyle(
//                                   letterSpacing: -0.3,
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 12.1,
//                                   color: Color.fromARGB(195, 41, 41, 41)),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // ............................ Suggestion Info ............................ //
//                 Container(
//                   margin:
//                       const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
//                   padding: const EdgeInsets.all(15),
//                   width: double.maxFinite,
//                   // height: 190,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Colors.white,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),
//                         spreadRadius: 0.5,
//                         blurRadius: 1.0,
//                         offset: const Offset(0, 0.5),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       // ..... Heading ....
//                       const Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'No. of Shares',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 13,
//                                 color: Color.fromARGB(195, 41, 41, 41)),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),

//                       // ..... Qty ....
//                       SizedBox(
//                         height: 45,
//                         child: TextFormField(
//                           controller: qtyController,
//                           autofocus: true,
//                           cursorHeight: 24,
//                           cursorWidth: 1,
//                           keyboardType: TextInputType.number,
//                           textAlign: TextAlign.start,
//                           textAlignVertical: TextAlignVertical.center,
//                           onChanged: (val) {},
//                           decoration: InputDecoration(
//                             contentPadding:
//                                 const EdgeInsets.only(bottom: 0, left: 10),
//                             suffixIcon: const Padding(
//                               padding: EdgeInsets.only(top: 10.0, right: 12),
//                               child: Text("Share",
//                                   style: TextStyle(
//                                       fontSize: 13.5, color: Colors.black54)),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(6),
//                                 borderSide: const BorderSide(
//                                     width: 0.5,
//                                     color: Color.fromARGB(65, 0, 0, 0))),
//                             focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(6),
//                                 borderSide: const BorderSide(
//                                     width: 0.5,
//                                     color: Color.fromARGB(65, 0, 0, 0))),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),

//                       // ..... Heading 2....
//                       const Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Buy Target',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 13,
//                                 color: Color.fromARGB(195, 41, 41, 41)),
//                           ),
//                           Text(
//                             'Options',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 13,
//                                 color: Color.fromARGB(195, 41, 41, 41)),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       SizedBox(
//                         height: 36,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             AmountFields(
//                               amountController: buyTargetController,
//                             ),
//                             ToggleSwitch(
//                               minHeight: 36,
//                               cornerRadius: 4,
//                               animate: true,
//                               animationDuration: 170,
//                               inactiveBgColor:
//                                   const Color.fromARGB(255, 232, 235, 244),
//                               activeBgColor: const [
//                                 Color.fromARGB(255, 38, 69, 206)
//                               ],
//                               initialLabelIndex: optionIndex.value,
//                               totalSwitches: 2,
//                               labels: stockBuyOptions,
//                               customTextStyles: const [
//                                 TextStyle(
//                                     fontWeight: FontWeight.w600, fontSize: 11)
//                               ],
//                               onToggle: (index) => optionIndex.value = index!,
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 20),

//                       // ..... Heading 3....
//                       const Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Sell Target',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 13,
//                                 color: Color.fromARGB(195, 41, 41, 41)),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       SizedBox(
//                         height: 36,
//                         child: Row(
//                           children: [
//                             AmountFields(
//                               amountController: sellTargetController,
//                             )
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),

//                 // ............................ Description ............................ //
//                 Container(
//                   margin:
//                       const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
//                   padding: const EdgeInsets.all(15),
//                   width: double.maxFinite,
//                   // height: 190,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Colors.white,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),
//                         spreadRadius: 0.5,
//                         blurRadius: 1.0,
//                         offset: const Offset(0, 0.5),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       // ..... Headphone ....
//                       const Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Description (Optional)',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 13,
//                                 color: Color.fromARGB(195, 41, 41, 41)),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       TextFormField(
//                         controller: descriptionController,
//                         maxLines: 2,
//                         cursorHeight: 25,
//                         cursorWidth: 0.7,
//                         cursorRadius: const Radius.circular(20),
//                         keyboardType: TextInputType.multiline,
//                         textCapitalization: TextCapitalization.characters,
//                         decoration: InputDecoration(
//                           hintText: "Add description",
//                           hintStyle: const TextStyle(fontSize: 13),
//                           enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(6),
//                               borderSide: const BorderSide(
//                                   width: 0.5,
//                                   color: Color.fromARGB(65, 0, 0, 0))),
//                           focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(6),
//                               borderSide: const BorderSide(
//                                   width: 0.5,
//                                   color: Color.fromARGB(135, 0, 0, 0))),
//                         ),
//                       ),
//                       const SizedBox(height: 20),

//                       // ....... Create Button .....
//                       InkWell(
//                         onTap: () async {
//                           try {
//                             await tradeSuggestiontW.createSuggestion(
//                                 context,
//                                 userId.value,
//                                 roomId,
//                                 selectedStock.value.id,
//                                 int.parse(qtyController.text),
//                                 double.parse(sellTargetController.text),
//                                 double.parse(buyTargetController.text),
//                                 descriptionController.text.isEmpty
//                                     ? null
//                                     : descriptionController.text.toString(),
//                                 stockBuyOptions[optionIndex.value]);
//                           } catch (error) {
//                             if (context.mounted) return;
//                             erroralert(context, "Unable to create",
//                                 "provide more information for suggestion");
//                           }
//                         },
//                         child: Container(
//                             width: double.maxFinite,
//                             height: 50,
//                             decoration: BoxDecoration(
//                                 color: const Color.fromARGB(255, 38, 69, 206),
//                                 borderRadius: BorderRadius.circular(7)),
//                             child: const Center(
//                               child: Text(
//                                 'CREATE',
//                                 textScaler: TextScaler.noScaling,
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 15),
//                               ),
//                             )),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ));
//   }
// }

// class AmountFields extends HookConsumerWidget {
//   final TextEditingController amountController;
//   const AmountFields({super.key, required this.amountController});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final size = MediaQuery.of(context).size;

//     return Row(
//       children: [
//         // minus button...
//         InkWell(
//           onTap: () {},
//           child: Container(
//             width: 38,
//             height: 47,
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(255, 225, 241, 238),
//               borderRadius: BorderRadius.circular(3),
//             ),
//             child: const Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Text(
//                   '-',
//                   style: TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.w600,
//                     color: Color.fromARGB(255, 3, 132, 98),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         // Amount field...
//         SizedBox(
//           width: size.width * 0.23,
//           height: 36,
//           child: TextFormField(
//             cursorHeight: 22,
//             cursorWidth: 1,
//             controller: amountController,
//             textAlign: TextAlign.center,
//             textDirection: TextDirection.ltr,
//             // enabled: isAmtEnb.value,
//             keyboardType: TextInputType.number,
//             onChanged: (val) {},
//             decoration: InputDecoration(
//               contentPadding: const EdgeInsets.only(bottom: 12),
//               enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(3),
//                   borderSide: const BorderSide(
//                       width: 0.5, color: Color.fromARGB(65, 0, 0, 0))),
//               focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(3),
//                   borderSide: const BorderSide(
//                       width: 0.5, color: Color.fromARGB(65, 0, 0, 0))),
//             ),
//           ),
//         ),
//         // Plus button...
//         InkWell(
//           onTap: () {},
//           child: Container(
//             width: 38,
//             height: 47,
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(255, 225, 241, 238),
//               borderRadius: BorderRadius.circular(3),
//             ),
//             child: const Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   '+',
//                   style: TextStyle(
//                       fontSize: 22,
//                       color: Color.fromARGB(255, 3, 132, 98),
//                       fontWeight: FontWeight.w600),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
