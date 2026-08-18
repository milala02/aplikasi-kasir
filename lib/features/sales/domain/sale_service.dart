import '../../../core/money/money.dart';
import 'sale.dart';
import 'sale_item.dart';

class SaleService {
  final Sale sale;

  const SaleService({
    required this.sale,
  });

  Money get subtotal => sale.subtotal;

  Money get total => sale.total;

  SaleService addItem(SaleItem item) {
    return SaleService(
      sale: Sale(
        id: sale.id,
        invoiceNumber: sale.invoiceNumber,
        items: [
          ...sale.items,
          item,
        ],
        discount: sale.discount,
        tax: sale.tax,
        createdAt: sale.createdAt,
      ),
    );
  }

  SaleService removeItemAt(int index) {
    if (index < 0 || index >= sale.items.length) {
      throw RangeError.index(
        index,
        sale.items,
        'index',
      );
    }

    final items = [
      ...sale.items,
    ]..removeAt(index);

    return SaleService(
      sale: Sale(
        id: sale.id,
        invoiceNumber: sale.invoiceNumber,
        items: items,
        discount: sale.discount,
        tax: sale.tax,
        createdAt: sale.createdAt,
      ),
    );
  }

  SaleService withDiscount(Money discount) {
    return SaleService(
      sale: Sale(
        id: sale.id,
        invoiceNumber: sale.invoiceNumber,
        items: sale.items,
        discount: discount,
        tax: sale.tax,
        createdAt: sale.createdAt,
      ),
    );
  }

  SaleService withTax(Money tax) {
    return SaleService(
      sale: Sale(
        id: sale.id,
        invoiceNumber: sale.invoiceNumber,
        items: sale.items,
        discount: sale.discount,
        tax: tax,
        createdAt: sale.createdAt,
      ),
    );
  }
}
