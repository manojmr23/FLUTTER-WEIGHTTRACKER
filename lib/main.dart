import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const primaryColor = Color(0xFF00695C);
  static const accentColor = Color(0xFF80CBC4);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Workout Planner",
      theme: ThemeData(
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal,
          accentColor: accentColor,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 4,
          centerTitle: true,
        ),
        cardTheme: CardTheme(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shadowColor: Colors.black26,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            elevation: 6,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
          hintStyle: TextStyle(color: Colors.grey.shade600),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryColor,
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      routes: {
        '/': (context) => const WorkoutListScreen(),
        '/scheduledWorkouts': (context) => const ScheduledWorkoutsScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/second') {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) {
              return WorkoutDetailScreen(
                workoutName: args["workoutName"]!,
                type: args["type"]!,
              );
            },
          );
        }
        return null;
      },
    );
  }
}

//
// InfoCard widget (Stateless, no function when clicked)
//
class InfoCard extends StatelessWidget {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.teal, size: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                "Welcome to Workout Planner! Tap any workout below to schedule your session.",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// Redesigned Workout List Screen
//
class WorkoutListScreen extends StatefulWidget {
  const WorkoutListScreen({super.key});

  @override
  State<WorkoutListScreen> createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen> {
  final List<Map<String, String>> workouts = [
    {
      "name": "Push-ups",
      "type": "Strength",
      "duration": "10 minutes",
      "image": "💪",
      "description": "A basic upper body strength exercise that targets chest, shoulders, and triceps.",
      "benefits": "Improves upper body strength, core stability, and endurance.",
      "tips": "Keep your body straight and lower yourself slowly."
    },
    {
      "name": "Running",
      "type": "Cardio",
      "duration": "30 minutes",
      "image": "🏃‍♂️",
      "description": "A cardiovascular exercise that enhances heart and lung health.",
      "benefits": "Boosts cardiovascular fitness, burns calories, and improves mental health.",
      "tips": "Maintain a steady pace and use good running form."
    },
    {
      "name": "Yoga",
      "type": "Flexibility",
      "duration": "20 minutes",
      "image": "🧘‍♀️",
      "description": "A practice combining physical postures, breathing techniques, and meditation.",
      "benefits": "Increases flexibility, reduces stress, and improves balance.",
      "tips": "Focus on your breathing and maintain proper alignment."
    },{
      "name": "Running",
      "type": "Cardio",
      "duration": "30 minutes",
      "image": "🏃‍♂️",
      "description": "A cardiovascular exercise that enhances heart and lung health.",
      "benefits": "Boosts cardiovascular fitness, burns calories, and improves mental health.",
      "tips": "Maintain a steady pace and use good running form."
    }
  ];

  String searchQuery = "";
  List<Map<String, String>> scheduledWorkouts = [];

  List<Map<String, String>> get uniqueWorkouts {
    final seen = <String>{};
    return workouts.where((workout) {
      final key = '${workout["name"]}_${workout["type"]}';
      if (seen.contains(key)) {
        return false;
      } else {
        seen.add(key);
        return true;
      }
    }).toList();
  }

  void cancelScheduling(int index) {
    setState(() {
      scheduledWorkouts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredWorkouts = uniqueWorkouts.where((workout) {
      final name = workout["name"]!.toLowerCase();
      final type = workout["type"]!.toLowerCase();
      return name.contains(searchQuery.toLowerCase()) ||
          type.contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Workouts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.event_note_outlined),
            tooltip: 'View Scheduled Workouts',
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/scheduledWorkouts',
                arguments: {
                  'scheduledWorkouts': scheduledWorkouts,
                  'onCancel': cancelScheduling,
                },
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search workouts by name or type",
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
            const InfoCard(), // 👈 Added Stateless widget here
            Expanded(
              child: filteredWorkouts.isEmpty
                  ? Center(
                      child: Text(
                        "No workouts found.",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredWorkouts.length,
                      itemBuilder: (context, index) {
                        final workout = filteredWorkouts[index];
                        return WorkoutCard(
                          workoutName: workout["name"]!,
                          type: workout["type"]!,
                          duration: workout["duration"]!,
                          iconEmoji: workout["image"] ?? "🏋️‍♂️",
                          onSchedule: (name, type) async {
                            final scheduled = await Navigator.pushNamed(
                              context,
                              '/second',
                              arguments: {
                                "workoutName": name,
                                "type": type,
                              },
                            );

                            if (scheduled != null &&
                                scheduled is Map<String, String>) {
                              final exists = scheduledWorkouts.any((s) =>
                                  s["name"] == scheduled["name"] &&
                                  s["date"] == scheduled["date"] &&
                                  s["time"] == scheduled["time"]);

                              if (exists) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "This workout slot is already scheduled!"),
                                  ),
                                );
                              } else {
                                setState(() {
                                  scheduledWorkouts.add(scheduled);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Workout scheduled: ${scheduled["name"]}!"),
                                  ),
                                );
                              }
                            }
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// New Workout Card Widget with modern design
//
class WorkoutCard extends StatelessWidget {
  final String workoutName;
  final String type;
  final String duration;
  final String iconEmoji;
  final Function(String, String) onSchedule;

  const WorkoutCard({
    super.key,
    required this.workoutName,
    required this.type,
    required this.duration,
    required this.iconEmoji,
    required this.onSchedule,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => onSchedule(workoutName, type),
        splashColor: Theme.of(context).primaryColor.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                ),
                padding: const EdgeInsets.all(16),
                child: Text(
                  iconEmoji,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workoutName,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$type · $duration",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => onSchedule(workoutName, type),
                child: const Text("Schedule"),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
// Redesigned Workout Detail Screen (Scheduling Form)
//
class WorkoutDetailScreen extends StatefulWidget {
  final String workoutName;
  final String type;

  const WorkoutDetailScreen(
      {super.key, required this.workoutName, required this.type});

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController userController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  DateTime? pickedDate;
  TimeOfDay? pickedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule ${widget.workoutName}"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Text(
                  "${widget.workoutName}",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.type,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 24),

                // User Name
                TextFormField(
                  controller: userController,
                  decoration: const InputDecoration(
                    labelText: "Your Name",
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your name" : null,
                ),
                const SizedBox(height: 20),

                // Notes
                TextFormField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: "Notes",
                    prefixIcon: Icon(Icons.note),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Please enter notes" : null,
                  maxLines: 3,
                ),
                const SizedBox(height: 30),

                // Date & Time Pickers
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: pickedDate ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            setState(() => pickedDate = date);
                          }
                        },
                        child: Card(
                          color: Colors.grey.shade100,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 16),
                            child: Column(
                              children: [
                                const Icon(Icons.calendar_today,
                                    color: Colors.teal),
                                const SizedBox(height: 8),
                                Text(
                                  pickedDate == null
                                      ? "Select Date"
                                      : "${pickedDate!.day}-${pickedDate!.month}-${pickedDate!.year}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: pickedDate == null
                                          ? Colors.grey[600]
                                          : Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: pickedTime ?? TimeOfDay.now(),
                          );
                          if (time != null) {
                            setState(() => pickedTime = time);
                          }
                        },
                        child: Card(
                          color: Colors.grey.shade100,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 16),
                            child: Column(
                              children: [
                                const Icon(Icons.access_time, color: Colors.teal),
                                const SizedBox(height: 8),
                                Text(
                                  pickedTime == null
                                      ? "Select Time"
                                      : "${pickedTime!.hour.toString().padLeft(2, '0')}:${pickedTime!.minute.toString().padLeft(2, '0')}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: pickedTime == null
                                          ? Colors.grey[600]
                                          : Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        pickedDate != null &&
                        pickedTime != null) {
                      Navigator.pop(context, {
                        "name": widget.workoutName,
                        "type": widget.type,
                        "user": userController.text,
                        "notes": notesController.text,
                        "date":
                            "${pickedDate!.day}-${pickedDate!.month}-${pickedDate!.year}",
                        "time":
                            "${pickedTime!.hour}:${pickedTime!.minute.toString().padLeft(2, '0')}",
                      });
                    } else {
                      if (pickedDate == null || pickedTime == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Please select date and time")),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Confirm Scheduling",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//
// Redesigned Scheduled Workouts Screen
//
class ScheduledWorkoutsScreen extends StatelessWidget {
  const ScheduledWorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final List<Map<String, String>> scheduledWorkouts =
        args['scheduledWorkouts'] ?? [];
    final Function(int)? onCancel = args['onCancel'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scheduled Workouts"),
      ),
      body: scheduledWorkouts.isEmpty
          ? const Center(
              child: Text(
                "No workouts scheduled yet.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: scheduledWorkouts.length,
              itemBuilder: (context, index) {
                final schedule = scheduledWorkouts[index];
                return Card(
                  elevation: 6,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.teal.shade100,
                      child: Text(
                        schedule["name"]!.substring(0, 1),
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      schedule["name"]!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Date: ${schedule["date"]}\nTime: ${schedule["time"]}\nBy: ${schedule["user"]}\nNotes: ${schedule["notes"]}",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_forever,
                          color: Colors.redAccent, size: 28),
                      onPressed: () => onCancel?.call(index),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
  