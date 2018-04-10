/**
 * Created by User on 10.04.2018.
 */

public class OrderManager {

    private final Set<Order> orders;

    public OrderManager() {
        this.orders = new Set<Order>();
    }

    public Boolean hasOrders() {
        return !this.orders.isEmpty();
    }

    public void orderAsc(String fieldName) {
        this.orders.add(new AscOrder(fieldName));
    }

    public void orderDesc(String fieldName) {
        this.orders.add(new DescOrder(fieldName));
    }

    public void orderAsc(String fieldName, Boolean nullsFirst) {
        this.orders.add(new AscOrder(fieldName, nullsFirst));
    }

    public void orderDesc(String fieldName, Boolean nullsFirst) {
        this.orders.add(new DescOrder(fieldName, nullsFirst));
    }

    public override String toString() {
        String result = '';
        if (this.hasOrders()) {
            result += 'ORDER BY ';
            List<String> orders = new List<String>();
            for (Order order : this.orders) {
                orders.add(order.toString());
            }
            result += String.join(orders, ', ') + ' ';
        }
        return result;
    }

    public abstract class Order {

        private final String sortingField;
        private final String sortingOrder;
        private Boolean nullsFirst;

        public Order(String sortingField, String sortingOrder) {
            this.sortingField = sortingField;
            this.sortingOrder = sortingOrder;
            this.nullsFirst = null;
        }

        public Order(String sortingField, String sortingOrder, Boolean nullsFirst) {
            this.sortingField = sortingField;
            this.sortingOrder = sortingOrder;
            this.nullsFirst = nullsFirst;
        }

        public override String toString() {
            String result = this.sortingField + ' ' + this.sortingOrder;
            if (this.nullsFirst != null) {
                result += this.nullsFirst ? 'NULLS FIRST' : 'NULLS LAST';
            }
            return result;
        }

        public Boolean equals(Object obj) {
            if (!(obj instanceof Order)) {
                return false;
            }
            Order compareTo = (Order) obj;
            return this.sortingField == compareTo.sortingField;
        }

        public Integer hashCode() {
            return sortingField.hashCode();
        }
    }

    public class AscOrder extends Order {

        public AscOrder(String sortingField) {
            super(sortingField, 'ASC');
        }

        public AscOrder(String sortingField, Boolean nullsFirst) {
            super(sortingField, 'ASC', nullsFirst);
        }
    }

    public class DescOrder extends Order {

        public DescOrder(String sortingField) {
            super(sortingField, 'DESC');
        }

        public DescOrder(String sortingField, Boolean nullsFirst) {
            super(sortingField, 'DESC', nullsFirst);
        }
    }
}