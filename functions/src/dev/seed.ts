import { initializeApp } from "firebase-admin/app";
import {
  DocumentReference,
  getFirestore,
  Timestamp,
} from "firebase-admin/firestore";
import { buildTitleSearch } from "../search/titleSearch";

process.env.FIRESTORE_EMULATOR_HOST ??= "127.0.0.1:8080";
process.env.GCLOUD_PROJECT ??= "event-horizon-v2";

initializeApp();
const db = getFirestore();

const categories = [
  { id: "music", name: "Âm nhạc" },
  { id: "workshop", name: "Workshop" },
  { id: "sport", name: "Thể thao" },
  { id: "art", name: "Nghệ thuật" },
  { id: "tech", name: "Công nghệ" },
  { id: "food", name: "Ẩm thực" },
];

const provinces = [
  { code: "SG", name: "TP. Hồ Chí Minh" },
  { code: "HN", name: "Hà Nội" },
  { code: "DN", name: "Đà Nẵng" },
  { code: "CT", name: "Cần Thơ" },
  { code: "DL", name: "Đà Lạt" },
];

const titleParts = [
  "Đêm nhạc Acoustic",
  "Lễ hội Ánh sáng",
  "Workshop Nhiếp ảnh",
  "Giải chạy Marathon",
  "Triển lãm Tranh",
  "Hội thảo AI",
  "Đại nhạc hội Mùa hè",
  "Chợ phiên Cuối tuần",
  "Kịch nói Sài Gòn",
  "Liveshow Bolero",
];

type Op = { ref: DocumentReference; data: Record<string, unknown> };

async function commitInChunks(ops: Op[]): Promise<void> {
  for (let i = 0; i < ops.length; i += 400) {
    const batch = db.batch();
    for (const op of ops.slice(i, i + 400)) {
      batch.set(op.ref, op.data);
    }
    await batch.commit();
  }
}

function daysFromNow(days: number): Timestamp {
  return Timestamp.fromMillis(Date.now() + days * 24 * 60 * 60 * 1000);
}

async function main(): Promise<void> {
  const ops: Op[] = [];

  for (const c of categories) {
    ops.push({
      ref: db.doc(`categories/${c.id}`),
      data: {
        name: c.name,
        status: "approved",
        createdBy: "seed",
        createdAt: Timestamp.now(),
      },
    });
  }

  for (let i = 1; i <= 50; i++) {
    const id = `evt${String(i).padStart(3, "0")}`;
    const cat = categories[i % categories.length];
    const prov = provinces[i % provinces.length];
    const title = titleParts[i % titleParts.length] + ` #${i}`;
    const status =
      i % 17 === 0 ? "draft" : i % 19 === 0 ? "pending" : "published";
    const isFree = i % 7 === 0;
    const startInDays = ((i * 3) % 60) - 5;

    let ticketTypes;
    if (isFree) {
      ticketTypes = [{ id: "t1", name: "Vé mời", price: 0, quantity: 200 }];
    } else {
      ticketTypes = [
        { id: "t1", name: "Thường", price: 2000, quantity: 100 },
        { id: "t2", name: "VIP", price: 5000, quantity: 50 },
      ];
    }
    let ticketsSold = 0;
    const ttOps: Op[] = ticketTypes.map((tt, idx) => {
      const sold = (i * 7 + idx * 13) % 40;
      ticketsSold += sold;
      return {
        ref: db.doc(`events/${id}/ticketTypes/${tt.id}`),
        data: {
          name: tt.name,
          description: "",
          price: tt.price,
          currency: "VND",
          quantity: tt.quantity,
          sold,
          seatCodes: null,
          sortOrder: idx,
          isActive: true,
        },
      };
    });
    ops.push({
      ref: db.doc(`events/${id}`),
      data: {
        title,
        titleSearch: buildTitleSearch(title),
        coverImageUrl: `https://picsum.photos/seed/${id}/800/450`,
        startAt: daysFromNow(startInDays),
        endAt: daysFromNow(startInDays + 1),
        venue: {
          name: `Nhà văn hoá ${prov.name}`,
          address: `${i} Đường Trung Tâm, ${prov.name}`,
          provinceCode: prov.code,
          wardCode: "",
          lat: 0,
          lng: 0,
        },
        categoryIds: [cat.id],
        categoryNames: [cat.name],
        organizerId: "seed-organizer",
        organizerName: "EventHorizon Demo",
        status,
        minPrice: ticketTypes[0].price,
        maxPrice: ticketTypes[ticketTypes.length - 1].price,
        ticketsSold,
        favoriteCount: 0,
        maxBookingsPerUser: 4,
        hasSeatMap: false,
        publishedAt: daysFromNow(-i),
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      },
    });
    ops.push({
      ref: db.doc(`events/${id}/content/main`),
      data: {
        descriptionDelta: null,
        descriptionPlain:
          `${title} — sự kiện demo sinh bởi seed script. ` +
          "Mô tả đủ dài để trang chi tiết có nội dung đọc được. " +
          "Địa điểm, thời gian và giá vé đều là dữ liệu giả lập.",
        permitDocUrl: "",
        commitmentAccepted: true,
        galleryUrls: [
          `https://picsum.photos/seed/${id}-1/800/450`,
          `https://picsum.photos/seed/${id}-2/800/450`,
        ],
      },
    });
    ops.push(...ttOps);
  }

  await commitInChunks(ops);
  console.log(`Seeded ${ops.length} documents (6 categories + 50 events).`);
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
