import 'package:breezodriver/features/trips/models/trip_model.dart';

class TripData {
  static TripModel getSampleTrip() {
    return TripModel(
      id: '232328271',
      assignedAt: '11:23am, Jan 24, 2025',
      startTime: '09:45',
      startLocation: 'Start',
      startAddress: '432, 2nd Cross Road, HAL 3rd Stage, Hosa Tippasandra, Bengaluru, Karnataka, India',
      endTime: '10:30',
      endLocation: 'Destination',
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
      ),
      Passenger(
        id: '2',
        name: 'Bhavika M.',
        address: '15, 1st Main Road, Gandhi Nagar, Bengaluru, Karnataka 560009, India',
        pickupTime: '10:12',
        initials: 'BM',
      ),
      Passenger(
        id: '3',
        name: 'Aman G.',
        address: '50, MG Road, Near Trinity Circle, Bengaluru, Karnataka 560001, India',
        pickupTime: '10:18',
        initials: 'AG',
      ),
      Passenger(
        id: '4',
        name: 'Vignesh B.',
        address: '22, 3rd Cross, Indiranagar, Bengaluru, Karnataka 560038, India',
        pickupTime: '10:25',
        initials: 'VB',
      ),
    ];
  }

  static List<TripModel> getSampleTrips() {
    return [
      // Assigned trips
      TripModel(
        id: '232328271',
        assignedAt: '11:23am, Jan 24, 2025',
        startTime: '09:45',
        startLocation: 'Start',
        startAddress: '432, 2nd Cross Road, HAL 3rd Stage, Bengaluru',
        endTime: '10:30',
        endLocation: 'Destination',
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
        assignedAt: '09:30am, Jan 24, 2025',
        startTime: '10:15',
        startLocation: 'Start',
        startAddress: 'Apartment 7B, Silver Heights, MG Road, Bangalore',
        endTime: '11:45',
        endLocation: 'Destination',
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
        assignedAt: '01:45pm, Jan 24, 2025',
        startTime: '03:30',
        startLocation: 'Start',
        startAddress: 'Villa 12, Palm Meadows, Whitefield',
        endTime: '04:45',
        endLocation: 'Destination',
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
        assignedAt: '08:15am, Jan 24, 2025',
        startTime: '08:45',
        startLocation: 'Start',
        startAddress: 'House 42, Green Valley, Koramangala',
        endTime: '09:30',
        endLocation: 'Destination',
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
        assignedAt: '12:10pm, Jan 24, 2025',
        startTime: '01:30',
        startLocation: 'Start',
        startAddress: 'Flat 203, Sunshine Apts, HSR Layout',
        endTime: '02:45',
        endLocation: 'Destination',
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
        assignedAt: '07:05am, Jan 24, 2025',
        startTime: '07:30',
        startLocation: 'Start',
        startAddress: 'Residence 8C, Golden Enclave, JP Nagar',
        endTime: '08:15',
        endLocation: 'Destination',
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
        assignedAt: '06:30am, Jan 24, 2025',
        startTime: '07:00',
        startLocation: 'Start',
        startAddress: 'Block D2, Brigade Gateway, Malleswaram',
        endTime: '08:00',
        endLocation: 'Destination',
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