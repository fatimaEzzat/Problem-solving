import 'package:task/task.dart';
import 'package:test/test.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

void main() {
  final task=Task();
  group('Product Quantity and Brand', () {
    String fileName = 'orders_data_0.csv';
    File inputFile = File(fileName);
    List<String> inputLines = inputFile.readAsLinesSync();

    String outputFileName1 = '0_${path.basename(fileName)}';
    String outputFileName2 = '1_${path.basename(fileName)}';

    test('Test output file names', () {
      expect(outputFileName1, equals('0_orders_data_0.csv'));
      expect(outputFileName2, equals('1_orders_data_0.csv'));
    });

    test('Test process product quantity information and popular brands', () {

      //Arrange
      Map<String, dynamic> expectedProcessedData = {
        'productQuantities':  {'Shoes': 8, 'Forks': 3},
        'productBrands':{'Shoes': {'Air': 2, 'BonPied': 1},
          'Forks': {'Pfitzcraft': 1}},
        'totalOrderNumber':4
      };

      //Act
      Map<String, dynamic> actualProcessedData = task.processData(inputLines);

      //Assert
      expect(actualProcessedData, equals(expectedProcessedData));
    });




    test('writes product name and average quantity of the product purchased per order output file', () {
      // Create a temporary file for testing
      final tempFile = File('test1.csv');

      // Arrange
      final productQuantities ={'Shoes': 8, 'Forks': 3};

      List<String> productNames=productQuantities.keys.toList();

      final expectedOutput = 'Shoes,2.0\nForks,0.75\n';

      // Arrange
      for (String productName in productNames) {
        task.writeProductQuantity(productQuantities, productName, tempFile,inputLines.length);
      }
      // Read the output file and verify the output
      final outputFileContents = tempFile.readAsStringSync();

      // Assert
      expect(outputFileContents, equals(expectedOutput));

      // Cleanup - delete the temporary file
      tempFile.deleteSync();
    });

    test('writes product name and most popular brand to output file', () {
      // Create a temporary file for testing
      final tempFile = File('test2.csv');

      // Arrange
      final productBrands = {
        'Shoes': {'Air': 2, 'BonPied': 1},
        'Forks': {'Pfitzcraft': 1}
      };

      List<String> productNames=productBrands.keys.toList();

      final expectedOutput = 'Shoes,Air\nForks,Pfitzcraft\n';

      // Act
      for (String productName in productNames) {
        task.writeProductsMostPopularBrands(productBrands, productName, tempFile);
      }
      // Assert
      final outputFileContents = tempFile.readAsStringSync();
      expect(outputFileContents, equals(expectedOutput));

      // Cleanup - delete the temporary file
      tempFile.deleteSync();
    });
  });
}
