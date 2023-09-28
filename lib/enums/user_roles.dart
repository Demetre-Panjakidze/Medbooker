enum UserRole {
  practitioner,
  member,
}

String getRole(UserRole role) {
  switch (role) {
    case UserRole.member:
      return 'member';
    case UserRole.practitioner:
      return 'practitioner';
    default:
      return 'member';
  }
}
