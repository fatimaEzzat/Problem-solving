

import 'dart:io';

Map<String, dynamic> processData(List<String> inputLines) {
 Map<String, dynamic> result = {};
 Map<String, int> productQuantities = {};
 Map<String, Map<String, int>> productBrands = {};

 int totalOrderNumber = inputLines.length;

 inputLines.forEach((line) {
  List<String> fields = line.split(',');
  String productName = fields[2];
  int quantity = int.tryParse(fields[3]) ?? 0;
  String brand = fields[4];

  // Update product quantity information ..collect products and number of items paid
  productQuantities.update(
   productName,
       (value) => value + quantity,
   ifAbsent: () => quantity,
  );

  // Update product brand information..collect product and most popular brand ..
  productBrands.update(
   productName,
       (value) {
    value.update(
     brand,
         (value) => value + 1,
     ifAbsent: () => 1,
    );
    return value;
   },
   ifAbsent: () => {brand: 1},
  );
 });

 result['productQuantities'] = productQuantities;
 result['productBrands'] = productBrands;
 result['totalOrderNumber'] = totalOrderNumber;

 return result;
}

void writeProductQuantity(Map<String, int> productQuantities, String productName, File outputFile, int totalOrderNumber) {
 double avgQuantity = productQuantities[productName]! / totalOrderNumber;
 String line = '$productName,${avgQuantity.toString()}\n';
 outputFile.writeAsStringSync(line, mode: FileMode.append);
}

void writeProductsMostPopularBrands(Map<String, Map<String, int>> productBrands, String productName, File outputFile) {
 String mostPopularBrand = productBrands[productName]!.entries.reduce((a, b) => a.value > b.value ? a : b).key;
 String line = '$productName,$mostPopularBrand\n';
 outputFile.writeAsStringSync(line, mode: FileMode.append);
}

// import 'dart:io';
//
// import 'package:path/path.dart' as path;
//
// Map<String, int> productQuantity(List<String> inputLines) {
//  Map<String, int> productQuantities = {};
//
//  for (String line in inputLines) {
//
//   List<String> fields = line.split(',');
//   String productName = fields[2];
//   int quantity = int.parse(fields[3]);
//
//   // Update product quantity information
//   if (!productQuantities.containsKey(productName)) {
//    productQuantities[productName] = quantity;
//   } else {
//    productQuantities[productName] =
//        productQuantities[productName]! + quantity;
//   }
//  }
//  return productQuantities;
// }
//
// Map<String, Map<String, int>> productBrand(List<String> inputLines) {
//  Map<String, Map<String, int>> productBrands = {};
//
//  for (String line in inputLines) {
//
//   List<String> fields = line.split(',');
//   String productName = fields[2];
//   String brand = fields[4];
//
//   // Update product brand information
//   if (!productBrands.containsKey(productName)) {
//    productBrands[productName] = {brand: 1};
//   } else {
//    if (!productBrands[productName]!.containsKey(brand)) {
//     productBrands[productName]![brand] = 1;
//    } else {
//     productBrands[productName]![brand] =
//         productBrands[productName]![brand]! + 1;
//    }
//   }
//  }
//  return productBrands;
// }
//
// void writeProductQuantity(Map<String, int> productQuantities,String productName,  File outputFile,int totalOrderNumber){
//  double avgQuantity = productQuantities[productName]! / totalOrderNumber;
//  String line = '$productName,${avgQuantity.toString()}, \n';
//  outputFile.writeAsStringSync(line, mode: FileMode.append);
// }
//
// void writeProductsMostPopularBrands(Map<String, Map<String, int>> productBrands,String productName,  File outputFile){
//  Map<String, int> brandCounts = productBrands[productName]!;
//  String mostPopularBrand = brandCounts.keys
//      .reduce((a, b) => brandCounts[a]! > brandCounts[b]! ? a : b);
//  String line = '$productName,$mostPopularBrand,\n';
//  outputFile.writeAsStringSync(line, mode: FileMode.append);
// }
//
//
