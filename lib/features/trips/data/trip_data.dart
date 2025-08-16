import 'package:breezodriver/features/trips/models/trip_model.dart';

class TripData {
  static TripModel getSampleTrip() {
    return TripModel(
      id: '232328271',
      assignedAt: DateTime.now(),
      startTime: DateTime.now(),
      startLocation: [],
      startAddress: '432, 2nd Cross Road, HAL 3rd Stage, Hosa Tippasandra, Bengaluru, Karnataka, India',
      endTime: DateTime.now().add(const Duration(hours: 1, minutes: 13)),
      endLocation: [],
      endAddress: '82, 28th Main, HBR Layout, Bengaluru, Karnataka 560043, India',
      duration: '01h 13m',
      distance: '20 kms',
      passengers: 4,
      status: 'Assigned',
      acceptBeforeTime: '1:23 min',
      passengerList: getSamplePassengers(),
    );
  }

  static List<Passenger> getSamplePassengers() {
    return [
      Passenger(
        id: '1',
        name: 'Bhavesh Kumar',
        address: 'Street 6 Block, Sriramapuram, Bangalore, Karnataka 560010, India',
        pickupTime: '09:50',
        initials: 'BK',
        location: [12.9715987, 77.594566],
      ),
      Passenger(
        id: '2',
        name: 'Bhavika M.',
        address: '15, 1st Main Road, Gandhi Nagar, Bengaluru, Karnataka 560009, India',
        pickupTime: '10:12',
        initials: 'BM',
        location: [12.9715987, 77.594566],
      ),
      Passenger(
        id: '3',
        name: 'Aman G.',
        address: '50, MG Road, Near Trinity Circle, Bengaluru, Karnataka 560001, India',
        pickupTime: '10:18',
        initials: 'AG',
        location: [12.9715987, 77.594566]
      ),
      Passenger(
        id: '4',
        name: 'Vignesh B.',
        address: '22, 3rd Cross, Indiranagar, Bengaluru, Karnataka 560038, India',
        pickupTime: '10:25',
        initials: 'VB',
        location: [12.9715987, 77.594566]
      ),
    ];
  }

  static List<TripModel> getSampleTrips() {
    return [
      // Assigned trips
      TripModel(
        id: '232328271',
        assignedAt: DateTime.now(),
        startTime: DateTime.now(),
        startLocation: [],
        startAddress: '432, 2nd Cross Road, HAL 3rd Stage, Bengaluru',
        endTime: DateTime.now().add(Duration(hours: 1, minutes: 13)),
        endLocation: [],
        endAddress: '82, 28th Main, HBR Layout, Bengaluru',
        duration: '01h 13m',
        distance: '20 kms',
        passengers: 4,
        status: 'Assigned',
        acceptBeforeTime: '1:23 min',
        passengerList: getSamplePassengers(),
      ),
      TripModel(
        id: '232328272',
        assignedAt: DateTime.now(),
        startTime: DateTime.now(),
        startLocation: [],
        startAddress: 'Apartment 7B, Silver Heights, MG Road, Bangalore',
        endTime: DateTime.now().add(Duration(hours: 1, minutes: 13)),
        endLocation: [],
        endAddress: 'Tower 3, Infosys Campus, Electronic City',
        duration: '01h 30m',
        distance: '18 kms',
        passengers: 3,
        status: 'Assigned',
        acceptBeforeTime: '2:05 min',
        passengerList: getSamplePassengers().sublist(0, 3),
      ),
      TripModel(
        id: '232328273',
        assignedAt: DateTime.now(),
        startTime: DateTime.now(),
        startLocation: [],
        startAddress: 'Villa 12, Palm Meadows, Whitefield',
        endTime: DateTime.now().add(Duration(hours: 1, minutes: 13)),
        endLocation: [],
        endAddress: 'Building 4, Embassy Tech Square, Outer Ring Road',
        duration: '01h 15m',
        distance: '15 kms',
        passengers: 2,
        status: 'Assigned',
        acceptBeforeTime: '0:45 min',
        passengerList: getSamplePassengers().sublist(0, 2),
      ),

      // Accepted trips
      TripModel(
        id: '232328274',
        assignedAt: DateTime.now(),
        startTime: DateTime.now(),
        startLocation: [],
        startAddress: 'House 42, Green Valley, Koramangala',
        endTime: DateTime.now().add(Duration(hours: 1, minutes: 13)),
        endLocation: [],
        endAddress: 'Microsoft IDC, Bagmane Tech Park',
        duration: '00h 45m',
        distance: '12 kms',
        passengers: 1,
        status: 'Accepted',
        acceptBeforeTime: 'Accepted',
        passengerList: getSamplePassengers().sublist(0, 1),
      ),
      TripModel(
        id: '232328275',
        assignedAt: DateTime.now(),
        startTime: DateTime.now(),
        startLocation: [],
        startAddress: 'Flat 203, Sunshine Apts, HSR Layout',
        endTime: DateTime.now().add(Duration(hours: 1, minutes: 13)),
        endLocation: [],
        endAddress: 'Amazon Development Center, Bellandur',
        duration: '01h 15m',
        distance: '14 kms',
        passengers: 2,
        status: 'Accepted',
        acceptBeforeTime: 'Accepted',
        passengerList: getSamplePassengers().sublist(1, 3),
      ),

      // Missed trip
      TripModel(
        id: '232328276',
        assignedAt: DateTime.now(),
        startTime: DateTime.now(),
        startLocation: [],
        startAddress: 'Residence 8C, Golden Enclave, JP Nagar',
        endTime: DateTime.now().add(Duration(hours: 1, minutes: 13)),
        endLocation: [],
        endAddress: 'Dell Office, Mahadevapura',
        duration: '00h 45m',
        distance: '10 kms',
        passengers: 2,
        status: 'Missed',
        acceptBeforeTime: 'Expired',
        passengerList: getSamplePassengers().sublist(2, 4),
      ),

      // Completed trip
      TripModel(
        id: '232328277',
        assignedAt: DateTime.now(),
        startTime: DateTime.now(),
        startLocation: [],
        startAddress: 'Block D2, Brigade Gateway, Malleswaram',
        endTime: DateTime.now().add(Duration(hours: 1, minutes: 13)),
        endLocation: [],
        endAddress: 'Google India Office, Bagmane World Technology Center',
        duration: '01h 00m',
        distance: '13 kms',
        passengers: 3,
        status: 'Completed',
        acceptBeforeTime: 'Completed',
        passengerList: getSamplePassengers().sublist(0, 3),
      ),
    ];
  }
}