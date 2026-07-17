export interface NewUserDocInput {
  uid: string;
  email: string;
  displayName: string;
}

export function buildNewUserDoc(input: NewUserDocInput) {
  return {
    id: input.uid,
    email: input.email,
    displayName: input.displayName,
    role: "user",
    organizerProfile: null,
    staffProfile: null,
    isActive: true,
    photoUrl: "",
    phoneNumber: "",
  };
}
