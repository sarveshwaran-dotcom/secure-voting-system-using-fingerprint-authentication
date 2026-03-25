import '../../domain/entities/party.dart';

class PartyData {
  // Tamil Nadu Parties 2026
  static final List<Party> tamilNaduParties = [
    const Party(
      id: '1',
      name: 'Dravida Munnetra Kazhagam (DMK)',
      leaderName: 'M. K. Stalin',
      leaderImageUrl: 'assets/images/leaders/dmk.jpg',
      symbolUrl: 'assets/images/symbols/dmk.png',
      flagUrl: 'assets/images/flags/dmk.png',
      isActive: true,
      order: 1,
    ),
    const Party(
      id: '2',
      name: 'All India Anna Dravida Munnetra Kazhagam (AIADMK)',
      leaderName: 'Edappadi K. Palaniswami',
      leaderImageUrl: 'assets/images/leaders/aiadmk.jpg',
      symbolUrl: 'assets/images/symbols/aiadmk.jpg',
      flagUrl: 'assets/images/flags/aiadmk.png',
      isActive: true,
      order: 2,
    ),
    const Party(
      id: '3',
      name: 'Tamilaga Vettri Kazhagam (TVK)',
      leaderName: 'Vijay',
      leaderImageUrl: 'assets/images/leaders/tvk.jpeg',
      symbolUrl: 'assets/images/symbols/tvk.png',
      flagUrl: 'assets/images/flags/tvk.jpg',
      isActive: true,
      order: 3,
    ),
    const Party(
      id: '4',
      name: 'Bharatiya Janata Party (BJP)',
      leaderName: 'K. Annamalai',
      leaderImageUrl: 'assets/images/leaders/bjp.jpg',
      symbolUrl: 'assets/images/symbols/bjp.png',
      flagUrl: 'assets/images/flags/bjp.png',
      isActive: true,
      order: 4,
    ),
    const Party(
      id: '5',
      name: 'Naam Tamilar Katchi (NTK)',
      leaderName: 'Seeman',
      leaderImageUrl: 'assets/images/leaders/ntk.jpg',
      symbolUrl: 'assets/images/symbols/ntk.jpg',
      flagUrl: 'assets/images/flags/ntk.jpg',
      isActive: true,
      order: 5,
    ),
    const Party(
      id: '6',
      name: 'Indian National Congress (INC)',
      leaderName: 'K. Selvaperunthagai',
      leaderImageUrl: 'assets/images/leaders/inc.jpg',
      symbolUrl: 'assets/images/symbols/inc.png',
      flagUrl: 'assets/images/flags/inc.png',
      isActive: true,
      order: 6,
    ),
    const Party(
      id: '7',
      name: 'Pattali Makkal Katchi (PMK)',
      leaderName: 'Anbumani Ramadoss',
      leaderImageUrl: 'assets/images/leaders/pmk.jpg',
      symbolUrl: 'assets/images/symbols/pmk.jpg',
      flagUrl: 'assets/images/flags/pmk.jpg',
      isActive: true,
      order: 7,
    ),
    const Party(
      id: '8',
      name: 'Viduthalai Chiruthaigal Katchi (VCK)',
      leaderName: 'Thol. Thirumavalavan',
      leaderImageUrl: 'assets/images/leaders/vck.jpg',
      symbolUrl: 'assets/images/symbols/vck.jpg',
      flagUrl: 'assets/images/flags/vck.png',
      isActive: true,
      order: 8,
    ),
  ];

  static List<Party> getActiveParties() {
    return tamilNaduParties.where((p) => p.isActive).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  static Party? getPartyById(String id) {
    try {
      return tamilNaduParties.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}

