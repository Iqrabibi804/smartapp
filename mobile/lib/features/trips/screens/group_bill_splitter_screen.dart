import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class GroupExpense {
  final String title;
  final double amount;
  final String paidBy;
  final String category; // Hotel, Fuel, Food, Tickets, Other

  GroupExpense({
    required this.title,
    required this.amount,
    required this.paidBy,
    required this.category,
  });
}

class GroupBillSplitterScreen extends StatefulWidget {
  const GroupBillSplitterScreen({super.key});

  @override
  State<GroupBillSplitterScreen> createState() => _GroupBillSplitterScreenState();
}

class _GroupBillSplitterScreenState extends State<GroupBillSplitterScreen> {
  final List<String> _members = ['Ali', 'Bilal', 'Usama', 'Hamza'];
  final List<GroupExpense> _expenses = [
    GroupExpense(title: 'Hotel Murree (1 Night)', amount: 6000, paidBy: 'Ali', category: 'Hotel'),
    GroupExpense(title: 'M2 Motorway Toll + Fuel', amount: 4800, paidBy: 'Bilal', category: 'Fuel'),
    GroupExpense(title: 'Dhaba Chappal Kebab & Chai', amount: 2400, paidBy: 'Usama', category: 'Food'),
    GroupExpense(title: 'Patriata Chairlift Tickets', amount: 2000, paidBy: 'Ali', category: 'Tickets'),
  ];

  final _newMemberController = TextEditingController();
  final _expenseTitleController = TextEditingController();
  final _expenseAmountController = TextEditingController();
  String _selectedPayer = 'Ali';
  String _selectedCategory = 'Food';

  @override
  void dispose() {
    _newMemberController.dispose();
    _expenseTitleController.dispose();
    _expenseAmountController.dispose();
    super.dispose();
  }

  double get _totalExpense => _expenses.fold(0.0, (sum, e) => sum + e.amount);
  double get _perPersonShare => _members.isNotEmpty ? _totalExpense / _members.length : 0.0;

  // Calculates who paid how much and net balance (+ for overpaid, - for owes)
  Map<String, double> _getBalances() {
    final Map<String, double> paidMap = {for (var m in _members) m: 0.0};
    for (final exp in _expenses) {
      if (paidMap.containsKey(exp.paidBy)) {
        paidMap[exp.paidBy] = paidMap[exp.paidBy]! + exp.amount;
      }
    }

    final share = _perPersonShare;
    final Map<String, double> balances = {};
    for (final m in _members) {
      balances[m] = (paidMap[m] ?? 0.0) - share;
    }
    return balances;
  }

  // Generates simplified settlement list (who pays whom)
  List<Map<String, dynamic>> _getSettlements() {
    final balances = _getBalances();
    final List<MapEntry<String, double>> debtors = [];
    final List<MapEntry<String, double>> creditors = [];

    balances.forEach((person, balance) {
      if (balance < -1) {
        debtors.add(MapEntry(person, -balance));
      } else if (balance > 1) {
        creditors.add(MapEntry(person, balance));
      }
    });

    debtors.sort((a, b) => b.value.compareTo(a.value));
    creditors.sort((a, b) => b.value.compareTo(a.value));

    final List<Map<String, dynamic>> settlements = [];
    int d = 0;
    int c = 0;

    final debtorsCopy = debtors.map((e) => MapEntry(e.key, e.value)).toList();
    final creditorsCopy = creditors.map((e) => MapEntry(e.key, e.value)).toList();

    while (d < debtorsCopy.length && c < creditorsCopy.length) {
      final debtor = debtorsCopy[d];
      final creditor = creditorsCopy[c];
      final amount = debtor.value < creditor.value ? debtor.value : creditor.value;

      if (amount > 1) {
        settlements.add({
          'from': debtor.key,
          'to': creditor.key,
          'amount': amount.round(),
        });
      }

      debtorsCopy[d] = MapEntry(debtor.key, debtor.value - amount);
      creditorsCopy[c] = MapEntry(creditor.key, creditor.value - amount);

      if (debtorsCopy[d].value <= 1) d++;
      if (creditorsCopy[c].value <= 1) c++;
    }

    return settlements;
  }

  void _shareOnWhatsApp() async {
    final balances = _getBalances();
    final settlements = _getSettlements();

    final buffer = StringBuffer();
    buffer.writeln('👥 *SmartMap Punjab - گروپ ٹرپ بل حساب کتاب* 🇵🇰');
    buffer.writeln('💰 *کل ٹرپ خرچہ:* Rs. ${_totalExpense.toStringAsFixed(0)}');
    buffer.writeln('👤 *فی کس حصہ (Per Person):* Rs. ${_perPersonShare.toStringAsFixed(0)}');
    buffer.writeln('────────────────────');
    buffer.writeln('📊 *کس نے کتنا خرچ کیا:*');
    for (final m in _members) {
      final bal = balances[m] ?? 0.0;
      final paid = (bal + _perPersonShare).round();
      buffer.writeln('• $m: ادا کیے Rs. $paid');
    }
    buffer.writeln('────────────────────');
    buffer.writeln('💸 *واپسی کا سیدھا حساب (Settlements):*');
    if (settlements.isEmpty) {
      buffer.writeln('✅ سب کا حساب برابر ہے!');
    } else {
      for (final s in settlements) {
        buffer.writeln('👉 *${s['from']}* بھیجے گا *${s['to']}* کو: *Rs. ${s['amount']}*');
      }
    }
    buffer.writeln('────────────────────');
    buffer.writeln('💡 *براہ کرم Easypaisa یا JazzCash سے جلد کلیئر کریں!*');
    buffer.writeln('📲 تیار کردہ بذریعہ SmartMap Punjab');

    final text = buffer.toString();
    final uri = Uri.parse('whatsapp://send?text=${Uri.encodeComponent(text)}');
    final fallbackUri = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (await canLaunchUrl(fallbackUri)) {
      await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('WhatsApp install nahi hai!')),
        );
      }
    }
  }

  void _showAddExpenseModal() {
    _expenseTitleController.clear();
    _expenseAmountController.clear();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                top: 20,
                left: 20,
                right: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('نیا خرچہ شامل کریں (Add Expense)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _expenseTitleController,
                    decoration: InputDecoration(
                      labelText: 'خرچے کی تفصیل (e.g. پٹرول، ہوٹل، کھانا، چائے)',
                      filled: true,
                      fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _expenseAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'رقم (PKR)',
                      prefixText: 'Rs. ',
                      filled: true,
                      fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('کس نے ادا کیا؟ (Paid By)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade400),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: _selectedPayer,
                                  items: _members.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                                  onChanged: (val) {
                                    if (val != null) setModalState(() => _selectedPayer = val);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('کیٹیگری (Category)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade400),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: _selectedCategory,
                                  items: ['Food', 'Hotel', 'Fuel', 'Tickets', 'Other']
                                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                                      .toList(),
                                  onChanged: (val) {
                                    if (val != null) setModalState(() => _selectedCategory = val);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF059669),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        final title = _expenseTitleController.text.trim();
                        final amount = double.tryParse(_expenseAmountController.text.trim());
                        if (title.isNotEmpty && amount != null && amount > 0) {
                          setState(() {
                            _expenses.add(GroupExpense(
                              title: title,
                              amount: amount,
                              paidBy: _selectedPayer,
                              category: _selectedCategory,
                            ));
                          });
                          Navigator.pop(ctx);
                        }
                      },
                      child: const Text('خرچہ شامل کریں', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAddMemberDialog() {
    _newMemberController.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('دوست کا نام شامل کریں'),
        content: TextField(
          controller: _newMemberController,
          decoration: const InputDecoration(hintText: 'e.g. Zeeshan'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('کینسل')),
          ElevatedButton(
            onPressed: () {
              final name = _newMemberController.text.trim();
              if (name.isNotEmpty && !_members.contains(name)) {
                setState(() => _members.add(name));
                Navigator.pop(ctx);
              }
            },
            child: const Text('شامل کریں'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final balances = _getBalances();
    final settlements = _getSettlements();

    return Scaffold(
      appBar: AppBar(
        title: const Text('گروپ بل اسپلٹر (Bill Splitter)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            tooltip: 'Share on WhatsApp',
            icon: const Icon(Icons.share, color: Color(0xFF22C55E)),
            onPressed: _shareOnWhatsApp,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddExpenseModal,
        backgroundColor: const Color(0xFF059669),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('خرچہ شامل کریں', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Summary Header Card ──
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('کل ٹرپ خرچہ (Total Spend)', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text(
                            'Rs. ${_totalExpense.toStringAsFixed(0)}',
                            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Text('فی کس حصہ', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                            Text(
                              'Rs. ${_perPersonShare.toStringAsFixed(0)}',
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Colors.white24, height: 1),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('گروپ ممبرز: ${_members.length} دوست', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      Text('کل اخراجات: ${_expenses.length} رسیدیں', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ── Group Members Chips ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('👥 گروپ ممبرز (Friends)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                TextButton.icon(
                  onPressed: _showAddMemberDialog,
                  icon: const Icon(Icons.person_add, size: 16, color: Color(0xFF059669)),
                  label: const Text('دوست شامل کریں', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                ),
              ],
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _members.map((m) {
                final bal = balances[m] ?? 0.0;
                final isPositive = bal >= 0;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                        child: Text(m[0], style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 6),
                      Text(m, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(width: 6),
                      Text(
                        isPositive ? '+Rs.${bal.round()}' : '-Rs.${(-bal).round()}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // ── Settlement Matrix (Who Pays Whom) ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.swap_horiz, color: Color(0xFFD97706), size: 20),
                      SizedBox(width: 8),
                      Text(
                        '💸 واپسی کا سیدھا حساب (Settlements)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF92400E)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (settlements.isEmpty)
                    const Text('سب کا حساب برابر ہے، کسی نے کسی کو پیسے نہیں دینے!', style: TextStyle(color: Color(0xFF78350F), fontSize: 12))
                  else
                    for (final s in settlements) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.arrow_right, color: Color(0xFFD97706), size: 18),
                            Text(s['from'], style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF991B1B))),
                            const Text(' دے گا ', style: TextStyle(color: Color(0xFF78350F))),
                            Text(s['to'], style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF166534))),
                            const Text(' کو: ', style: TextStyle(color: Color(0xFF78350F))),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD97706),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Rs. ${s['amount']}',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Icon(Icons.payment, size: 14, color: Color(0xFFD97706)),
                      SizedBox(width: 6),
                      Text(
                        '💡 Easypaisa یا JazzCash سے فوری ٹرانسفر کر کے کلیئر کریں',
                        style: TextStyle(fontSize: 11, color: Color(0xFF78350F), fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Expenses List ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('🧾 اخراجات کی تفصیل (Trip Expenses)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text('${_expenses.length} رسیدیں', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),

            for (int i = 0; i < _expenses.length; i++) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _categoryColor(_expenses[i].category).withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(_categoryIcon(_expenses[i].category), color: _categoryColor(_expenses[i].category), size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_expenses[i].title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 2),
                          Text('ادائیگی: ${_expenses[i].paidBy} (${_expenses[i].category})', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ),
                    Text(
                      'Rs. ${_expenses[i].amount.toStringAsFixed(0)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 16, color: Colors.grey),
                      onPressed: () => setState(() => _expenses.removeAt(i)),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            // ── Share WhatsApp Button ──
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _shareOnWhatsApp,
                icon: const Icon(Icons.chat, size: 20),
                label: const Text(
                  'واٹس ایپ پر گروپ حساب کتاب شیئر کریں',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Color _categoryColor(String cat) {
    switch (cat) {
      case 'Hotel':
        return const Color(0xFF2563EB);
      case 'Fuel':
        return const Color(0xFFD97706);
      case 'Food':
        return const Color(0xFF059669);
      case 'Tickets':
        return const Color(0xFF7C3AED);
      default:
        return const Color(0xFF64748B);
    }
  }

  IconData _categoryIcon(String cat) {
    switch (cat) {
      case 'Hotel':
        return Icons.hotel;
      case 'Fuel':
        return Icons.local_gas_station;
      case 'Food':
        return Icons.restaurant;
      case 'Tickets':
        return Icons.confirmation_number;
      default:
        return Icons.receipt_long;
    }
  }
}
