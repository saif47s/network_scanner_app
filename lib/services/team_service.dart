import 'package:cloud_firestore/cloud_firestore.dart';

class TeamService {
  final String userId;
  final _firestore = FirebaseFirestore.instance;

  TeamService({required this.userId});

  // Stream of teams this user belongs to
  Stream<List<Map<String, dynamic>>> myTeams() {
    return _firestore
        .collection('teams')
        .where('members.$userId', isGreaterThan: '')
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).toList());
  }

  // Check permission for a team
  Future<String?> getUserRole(String teamId) async {
    final teamDoc = await _firestore.collection('teams').doc(teamId).get();
    return teamDoc.data()?['members'][userId] as String?;
  }

  // Add user to team with role
  Future<void> addMember(String teamId, String memberId, String role) async {
    await _firestore.collection('teams').doc(teamId).update({
      'members.$memberId': role,
    });
  }

  // Remove user
  Future<void> removeMember(String teamId, String memberId) async {
    await _firestore.collection('teams').doc(teamId).update({
      'members.$memberId': FieldValue.delete(),
    });
  }
}
