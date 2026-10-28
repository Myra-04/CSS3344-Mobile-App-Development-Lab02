
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const StudentInfoApp());
}

class StudentInfoApp extends StatelessWidget {
  const StudentInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSS3344 Lab 02',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const StudentProfileScreen(),
    );
  }
}

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() =>
      _StudentProfileScreenState();
}

class _StudentProfileScreenState
    extends State<StudentProfileScreen> {

  DateTime? _selectedDate;
  String _selectedRole = 'Student';

  final List<String> _roles = [
    'Student',
    'Developer',
    'Designer',
  ];

  Future<void> _selectMaterialDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null && mounted) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showCupertinoDatePicker(BuildContext context) {
    final DateTime now = DateTime.now();

    showCupertinoModalPopup<void>(
      context: context,
      builder: (popupContext) => Container(
        height: 300,
        color: CupertinoColors.systemBackground
            .resolveFrom(popupContext),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: CupertinoButton(
                  onPressed: () {
                    Navigator.pop(popupContext);
                  },
                  child: const Text('Done'),
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _selectedDate ?? now,
                  minimumDate: DateTime(1950),
                  maximumDate: now,
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() {
                      _selectedDate = newDate;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCupertinoRolePicker(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (popupContext) => Container(
        height: 250,
        color: CupertinoColors.systemBackground
            .resolveFrom(popupContext),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: CupertinoButton(
                  onPressed: () {
                    Navigator.pop(popupContext);
                  },
                  child: const Text('Done'),
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 32,
                  scrollController: FixedExtentScrollController(
                    initialItem: _roles.indexOf(_selectedRole),
                  ),
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      _selectedRole = _roles[index];
                    });
                  },
                  children: _roles.map((role) {
                    return Center(
                      child: Text(role),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CSS3344 Mobile App Dev - Lab 02',
        ),
        centerTitle: true,
        backgroundColor:
        Theme.of(context).colorScheme.primaryContainer,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _buildPortraitView()
              : _buildLandscapeView();
        },
      ),
    );
  }

  Widget _buildPortraitView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const StudentDetailsSection(),
        const SizedBox(height: 16),
        _buildLocationCard(),
        const SizedBox(height: 16),
        _buildDatePickerSection(),
      ],
    );
  }

  Widget _buildLandscapeView() {
    return Row(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              StudentDetailsSection(),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildLocationCard(),
              const SizedBox(height: 16),
              _buildDatePickerSection(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationCard() {
    return Card(
      elevation: 4,
      child: Column(
        children: [
          const SizedBox(height: 16),

          const Text(
            'Location Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Divider(),

          const TitleSection(
            name: 'Hogwarts School of Witchcraft and Wizardry',
            location: 'Hogsmeade, Scotland',
            starCount: 41,
          ),

          const ImageSection(
            imagePath: 'assets/aurora.jpg',
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDatePickerSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              'Interactive Pickers (Lab 2.2)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              _selectedDate == null
                  ? 'Selected Date: Not selected'
                  : 'Selected Date: ${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}',
            ),

            const SizedBox(height: 8),

            Text(
              'Selected Role: $_selectedRole',
              style: const TextStyle(
                color: Colors.indigo,
                fontSize: 15,
              ),
            ),

            const Divider(height: 24),

            ElevatedButton(
              onPressed: () {
                _selectMaterialDate(context);
              },
              child: const Text('Material Date Picker'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                _showCupertinoDatePicker(context);
              },
              child: const Text('Cupertino Date Picker'),
            ),

            const Divider(height: 24),

            const Text(
              'Material Dropdown:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            DropdownButton<String>(
              value: _selectedRole,
              isExpanded: true,
              items: _roles.map((String role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedRole = newValue;
                  });
                }
              },
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                _showCupertinoRolePicker(context);
              },
              child: const Text('Cupertino Wheel Picker'),
            ),

          ],
        ),
      ),
    );
  }
}

class StudentDetailsSection extends StatelessWidget {
  const StudentDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.indigo,
              backgroundImage: AssetImage(
                'assets/photo_2026-10-21_19-51-59.jpg',
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'MYRA FASHA HANIEYZA BINTI YUSRI',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Student ID: BCS24090050',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const Divider(
              height: 32,
              thickness: 1,
            ),

            const Text(
              'Personal Life Goal / Quote:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              '"Life doesnt give you a safety car, everytime things get difficult"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: Colors.indigo,
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  final String name;
  final String location;
  final int starCount;

  const TitleSection({
    super.key,
    required this.name,
    required this.location,
    required this.starCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  location,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.star,
            color: Colors.red[500],
          ),

          const SizedBox(width: 4),

          Text('$starCount'),
        ],
      ),
    );
  }
}

class ImageSection extends StatelessWidget {
  final String imagePath;

  const ImageSection({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          imagePath,
          width: double.infinity,
          height: 220,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
