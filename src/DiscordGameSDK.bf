using System;

using internal Discord;

namespace Discord {
	static {

		public const int32 DISCORD_VERSION = 2;
		public const int32 DISCORD_APPLICATION_MANAGER_VERSION = 1;
		public const int32 DISCORD_USER_MANAGER_VERSION = 1;
		public const int32 DISCORD_IMAGE_MANAGER_VERSION = 1;
		public const int32 DISCORD_ACTIVITY_MANAGER_VERSION = 1;
		public const int32 DISCORD_RELATIONSHIP_MANAGER_VERSION = 1;
		public const int32 DISCORD_LOBBY_MANAGER_VERSION = 1;
		public const int32 DISCORD_NETWORK_MANAGER_VERSION = 1;
		public const int32 DISCORD_OVERLAY_MANAGER_VERSION = 1;
		public const int32 DISCORD_STORAGE_MANAGER_VERSION = 1;
		public const int32 DISCORD_STORE_MANAGER_VERSION = 1;
		public const int32 DISCORD_VOICE_MANAGER_VERSION = 1;
		public const int32 DISCORD_ACHIEVEMENT_MANAGER_VERSION = 1;

		public enum EDiscordResult {
			Ok = 0,
			ServiceUnavailable = 1,
			InvalidVersion = 2,
			LockFailed = 3,
			InternalError = 4,
			InvalidPayload = 5,
			InvalidCommand = 6,
			InvalidPermissions = 7,
			NotFetched = 8,
			NotFound = 9,
			Conflict = 10,
			InvalidSecret = 11,
			InvalidJoinSecret = 12,
			NoEligibleActivity = 13,
			InvalidInvite = 14,
			NotAuthenticated = 15,
			InvalidAccessToken = 16,
			ApplicationMismatch = 17,
			InvalidDataUrl = 18,
			InvalidBase64 = 19,
			NotFiltered = 20,
			LobbyFull = 21,
			InvalidLobbySecret = 22,
			InvalidFilename = 23,
			InvalidFileSize = 24,
			InvalidEntitlement = 25,
			NotInstalled = 26,
			NotRunning = 27,
			InsufficientBuffer = 28,
			PurchaseCanceled = 29,
			InvalidGuild = 30,
			InvalidEvent = 31,
			InvalidChannel = 32,
			InvalidOrigin = 33,
			RateLimited = 34,
			OAuth2Error = 35,
			SelectChannelTimeout = 36,
			GetGuildTimeout = 37,
			SelectVoiceForceRequired = 38,
			CaptureShortcutAlreadyListening = 39,
			UnauthorizedForAchievement = 40,
			InvalidGiftCode = 41,
			PurchaseError = 42,
			TransactionAborted = 43,
		};

		public enum EDiscordCreateFlags {
			Default = 0,
			NoRequireDiscord = 1,
		};

		public enum EDiscordLogLevel {
			Error = 1,
			Warn,
			Info,
			Debug,
		};

		public enum EDiscordUserFlag {
			Partner = 2,
			HypeSquadEvents = 4,
			HypeSquadHouse1 = 64,
			HypeSquadHouse2 = 128,
			HypeSquadHouse3 = 256,
		};

		public enum EDiscordPremiumType {
			None = 0,
			Tier1 = 1,
			Tier2 = 2,
		};

		public enum EDiscordImageType {
			User,
		};

		public enum EDiscordActivityType {
			Playing,
			Streaming,
			Listening,
			Watching,
		};

		public enum EDiscordActivityActionType {
			Join = 1,
			Spectate,
		};

		public enum EDiscordActivityJoinRequestReply {
			No,
			Yes,
			Ignore,
		};

		public enum EDiscordStatus {
			Offline = 0,
			Online = 1,
			Idle = 2,
			DoNotDisturb = 3,
		};

		public enum EDiscordRelationshipType {
			None,
			Friend,
			Blocked,
			PendingIncoming,
			PendingOutgoing,
			Implicit,
		};

		public enum EDiscordLobbyType {
			Private = 1,
			Public,
		};

		public enum EDiscordLobbySearchComparison {
			LessThanOrEqual = -2,
			LessThan,
			Equal,
			GreaterThan,
			GreaterThanOrEqual,
			NotEqual,
		};

		public enum EDiscordLobbySearchCast {
			String = 1,
			Number,
		};

		public enum EDiscordLobbySearchDistance {
			Local,
			Default,
			Extended,
			Global,
		};

		public enum EDiscordEntitlementType {
			Purchase = 1,
			PremiumSubscription,
			DeveloperGift,
			TestModePurchase,
			FreePurchase,
			UserGift,
			PremiumPurchase,
		};

		public enum EDiscordSkuType {
			Application = 1,
			DLC,
			Consumable,
			Bundle,
		};

		public enum EDiscordInputModeType {
			VoiceActivity = 0,
			PushToTalk,
		};

		public typealias DiscordClientId = int64;
		public typealias DiscordVersion = int32;
		public typealias DiscordSnowflake = int64;
		public typealias DiscordTimestamp = int64;
		public typealias DiscordUserId = DiscordSnowflake;
		public typealias DiscordLocale = char8[128];
		public typealias DiscordBranch = char8[4096];
		public typealias DiscordLobbyId = DiscordSnowflake;
		public typealias DiscordLobbySecret = char8[128];
		public typealias DiscordMetadataKey = char8[256];
		public typealias DiscordMetadataValue = char8[4096];
		public typealias DiscordNetworkPeerId = uint64;
		public typealias DiscordNetworkChannelId = uint8;
		public typealias DiscordPath = char8[4096];
		public typealias DiscordDateTime = char8[64];

		internal static mixin MakeFromCharBuffer(var buffer)
		{
			var s = StringView(&buffer[0], buffer.Count);
			for (int i < buffer.Count)
				if (buffer[i] == (char8)0)
					s.Length = i;
			s // Equate to appropriately sized view
		}

		internal static mixin SetCharBuffer(var buffer, StringView str)
		{
			str.CopyTo(Span<char8>(&buffer[0], buffer.Count));

			if (buffer.Count > str.Length)
				Internal.MemSet(&buffer[str.Length], 0, buffer.Count - str.Length); // Clear remaining
		}

		// Use these to pass strings into functions that require "DiscordLobbySecret", ... (fixed sized arrays)
		public static mixin MakeCharBuffer<Size>(Size expectedSize, StringView str) where Size : const int
		{
			char8[Size] buf = .();
			let limit = Math.Min((int)Size, str.Length);
			Internal.MemCpy(&buf[0], &str[0], limit);
			buf
		}

		[CRepr]
		public struct DiscordUser {
			public DiscordUserId id;
			public char8[256] username;
			public char8[8] discriminator;
			public char8[128] avatar;
			public bool bot;

			public StringView Username
			{
				get => MakeFromCharBuffer!(username);
				set => SetCharBuffer!(username, value);
			}

			public StringView Discriminator
			{
				get => MakeFromCharBuffer!(discriminator);
				set => SetCharBuffer!(discriminator, value);
			}

			public StringView Avatar
			{
				get => MakeFromCharBuffer!(avatar);
				set => SetCharBuffer!(avatar, value);
			}
		};

		[CRepr]
		public struct DiscordOAuth2Token {
			public char8[128] access_token;
			public char8[1024] scopes;
			public DiscordTimestamp expires;

			public StringView AccessToken
			{
				get => MakeFromCharBuffer!(access_token);
				set => SetCharBuffer!(access_token, value);
			}

			public StringView Scopes
			{
				get => MakeFromCharBuffer!(scopes);
				set => SetCharBuffer!(scopes, value);
			}
		};

		[CRepr]
		public struct DiscordImageHandle {
			public EDiscordImageType type;
			public int64 id;
			public uint32 size;
		};

		[CRepr]
		public struct DiscordImageDimensions {
			public uint32 width;
			public uint32 height;
		};

		[CRepr]
		public struct DiscordActivityTimestamps {
			public DiscordTimestamp start;
			public DiscordTimestamp end;
		};

		[CRepr]
		public struct DiscordActivityAssets {
			public char8[128] large_image;
			public char8[128] large_text;
			public char8[128] small_image;
			public char8[128] small_text;

			public StringView LargeImage
			{
				get => MakeFromCharBuffer!(large_image);
				set => SetCharBuffer!(large_image, value);
			}

			public StringView LargeText
			{
				get => MakeFromCharBuffer!(large_text);
				set => SetCharBuffer!(large_text, value);
			}

			public StringView SmallImage
			{
				get => MakeFromCharBuffer!(small_image);
				set => SetCharBuffer!(small_image, value);
			}

			public StringView SmallText
			{
				get => MakeFromCharBuffer!(small_text);
				set => SetCharBuffer!(small_text, value);
			}
		};

		[CRepr]
		public struct DiscordPartySize {
			public int32 current_size;
			public int32 max_size;
		};

		[CRepr]
		public struct DiscordActivityParty {
			public char8[128] id;
			public DiscordPartySize size;

			public StringView Id
			{
				get => MakeFromCharBuffer!(id);
				set => SetCharBuffer!(id, value);
			}
		};

		[CRepr]
		public struct DiscordActivitySecrets {
			public char8[128] match;
			public char8[128] join;
			public char8[128] spectate;

			public StringView Match
			{
				get => MakeFromCharBuffer!(match);
				set => SetCharBuffer!(match, value);
			}

			public StringView Join
			{
				get => MakeFromCharBuffer!(join);
				set => SetCharBuffer!(join, value);
			}

			public StringView Spectate
			{
				get => MakeFromCharBuffer!(spectate);
				set => SetCharBuffer!(spectate, value);
			}
		};

		[CRepr]
		public struct DiscordActivity {
			public EDiscordActivityType type;
			public int64 application_id;
			public char8[128] name;
			public char8[128] state;
			public char8[128] details;
			public DiscordActivityTimestamps timestamps;
			public DiscordActivityAssets assets;
			public DiscordActivityParty party;
			public DiscordActivitySecrets secrets;
			public bool instance;

			public StringView Name
			{
				get => MakeFromCharBuffer!(name);
				set => SetCharBuffer!(name, value);
			}

			public StringView State
			{
				get => MakeFromCharBuffer!(state);
				set => SetCharBuffer!(state, value);
			}

			public StringView Details
			{
				get => MakeFromCharBuffer!(details);
				set => SetCharBuffer!(details, value);
			}
		};

		[CRepr]
		public struct DiscordPresence {
			public EDiscordStatus status;
			public DiscordActivity activity;
		};

		[CRepr]
		public struct DiscordRelationship {
			public EDiscordRelationshipType type;
			public DiscordUser user;
			public DiscordPresence presence;
		};

		[CRepr]
		public struct DiscordLobby {
			public DiscordLobbyId id;
			public EDiscordLobbyType type;
			public DiscordUserId owner_id;
			public DiscordLobbySecret secret;
			public uint32 capacity;
			public bool locked;

			public StringView Secret
			{
				get => MakeFromCharBuffer!(secret);
				set => SetCharBuffer!(secret, value);
			}
		};

		[CRepr]
		public struct DiscordFileStat {
			public char8[260] filename;
			public uint64 size;
			public uint64 last_modified;

			public StringView Filename
			{
				get => MakeFromCharBuffer!(filename);
				set => SetCharBuffer!(filename, value);
			}
		};

		[CRepr]
		public struct DiscordEntitlement {
			public DiscordSnowflake id;
			public EDiscordEntitlementType type;
			public DiscordSnowflake sku_id;
		};

		[CRepr]
		public struct DiscordSkuPrice {
			public uint32 amount;
			public char8[16] currency;

			public StringView Currency
			{
				get => MakeFromCharBuffer!(currency);
				set => SetCharBuffer!(currency, value);
			}
		};

		[CRepr]
		public struct DiscordSku {
			public DiscordSnowflake id;
			public EDiscordSkuType type;
			public char8[256] name;
			public DiscordSkuPrice price;

			public StringView Name
			{
				get => MakeFromCharBuffer!(name);
				set => SetCharBuffer!(name, value);
			}
		};

		[CRepr]
		public struct DiscordInputMode {
			public EDiscordInputModeType type;
			public char8[256] shortcut;

			public StringView Shortcut
			{
				get => MakeFromCharBuffer!(shortcut);
				set => SetCharBuffer!(shortcut, value);
			}
		};

		[CRepr]
		public struct DiscordUserAchievement {
			public DiscordSnowflake user_id;
			public DiscordSnowflake achievement_id;
			public uint8 percent_complete;
			public DiscordDateTime unlocked_at;

			public StringView UnlockedAt
			{
				get => MakeFromCharBuffer!(unlocked_at);
				set => SetCharBuffer!(unlocked_at, value);
			}
		};

		public function void Callback(void* callback_data, EDiscordResult result);
		public function void OAuth2TokenCallback(void* callback_data, EDiscordResult result, DiscordOAuth2Token* oauth2_token);
		public function void StringCallback(void* callback_data, EDiscordResult result, char8* data);
		public function void UserCallback(void* callback_data, EDiscordResult result, DiscordUser* user);
		public function void ImageHandleCallback(void* callback_data, EDiscordResult result, DiscordImageHandle handle_result);
		public function bool RelationshipFilter(void* filter_data, DiscordRelationship* relationship);
		public function void LobbyCallback(void* callback_data, EDiscordResult result, DiscordLobby* lobby);
		public function void ByteCallback(void* callback_data, EDiscordResult result, uint8* data, uint32 data_length);
		public function void LogHook(void* hook_data, EDiscordLogLevel level, char8* message);

		[CRepr]
		public struct IDiscordLobbyTransaction {
			public function EDiscordResult __set_type(IDiscordLobbyTransaction* lobby_transaction, EDiscordLobbyType type);
			public __set_type set_type;
			public function EDiscordResult __set_owner(IDiscordLobbyTransaction* lobby_transaction, DiscordUserId owner_id);
			public __set_owner set_owner;
			public function EDiscordResult __set_capacity(IDiscordLobbyTransaction* lobby_transaction, uint32 capacity);
			public __set_capacity set_capacity;
			public function EDiscordResult __set_metadata(IDiscordLobbyTransaction* lobby_transaction, DiscordMetadataKey key, DiscordMetadataValue value);
			public __set_metadata set_metadata;
			public function EDiscordResult __delete_metadata(IDiscordLobbyTransaction* lobby_transaction, DiscordMetadataKey key);
			public __delete_metadata delete_metadata;
			public function EDiscordResult __set_locked(IDiscordLobbyTransaction* lobby_transaction, bool locked);
			public __set_locked set_locked;
		};

		[CRepr]
		public struct IDiscordLobbyMemberTransaction {
			public function EDiscordResult __set_metadata(IDiscordLobbyMemberTransaction* lobby_member_transaction, DiscordMetadataKey key, DiscordMetadataValue value);
			public __set_metadata set_metadata;
			public function EDiscordResult __delete_metadata(IDiscordLobbyMemberTransaction* lobby_member_transaction, DiscordMetadataKey key);
			public __delete_metadata delete_metadata;
		};

		[CRepr]
		public struct IDiscordLobbySearchQuery {
			public function EDiscordResult __filter(IDiscordLobbySearchQuery* lobby_search_query, DiscordMetadataKey key, EDiscordLobbySearchComparison comparison, EDiscordLobbySearchCast cast, DiscordMetadataValue value);
			public __filter filter;
			public function EDiscordResult __sort(IDiscordLobbySearchQuery* lobby_search_query, DiscordMetadataKey key, EDiscordLobbySearchCast cast, DiscordMetadataValue value);
			public __sort sort;
			public function EDiscordResult __limit(IDiscordLobbySearchQuery* lobby_search_query, uint32 limit);
			public __limit limit;
			public function EDiscordResult __distance(IDiscordLobbySearchQuery* lobby_search_query, EDiscordLobbySearchDistance distance);
			public __distance distance;
		};

		public typealias IDiscordApplicationEvents = void*;

		[CRepr]
		public struct IDiscordApplicationManager {
			public function void __validate_or_exit(IDiscordApplicationManager* manager, void* callback_data, Callback callback);
			public __validate_or_exit validate_or_exit;
			public function void __get_current_locale(IDiscordApplicationManager* manager, DiscordLocale* locale);
			public __get_current_locale get_current_locale;
			public function void __get_current_branch(IDiscordApplicationManager* manager, DiscordBranch* branch);
			public __get_current_branch get_current_branch;
			public function void __get_oauth2_token(IDiscordApplicationManager* manager, void* callback_data, OAuth2TokenCallback callback);
			public __get_oauth2_token get_oauth2_token;
			public function void __get_ticket(IDiscordApplicationManager* manager, void* callback_data, StringCallback callback);
			public __get_ticket get_ticket;
		};

		[CRepr]
		public struct IDiscordUserEvents {
			public function void __on_current_user_update(void* event_data);
			public __on_current_user_update on_current_user_update;
		};

		[CRepr]
		public struct IDiscordUserManager {
			public function EDiscordResult __get_current_user(IDiscordUserManager* manager, DiscordUser* current_user);
			public __get_current_user get_current_user;
			public function void __get_user(IDiscordUserManager* manager, DiscordUserId user_id, void* callback_data, UserCallback callback);
			public __get_user get_user;
			public function EDiscordResult __get_current_user_premium_type(IDiscordUserManager* manager, EDiscordPremiumType* premium_type);
			public __get_current_user_premium_type get_current_user_premium_type;
			public function EDiscordResult __current_user_has_flag(IDiscordUserManager* manager, EDiscordUserFlag flag, bool* has_flag);
			public __current_user_has_flag current_user_has_flag;
		};

		typealias IDiscordImageEvents = void*;

		[CRepr]
		public struct IDiscordImageManager {
			public function void __fetch(IDiscordImageManager* manager, DiscordImageHandle handle, bool refresh, void* callback_data, ImageHandleCallback callback);
			public __fetch fetch;
			public function EDiscordResult __get_dimensions(IDiscordImageManager* manager, DiscordImageHandle handle, DiscordImageDimensions* dimensions);
			public __get_dimensions get_dimensions;
			public function EDiscordResult __get_data(IDiscordImageManager* manager, DiscordImageHandle handle, uint8* data, uint32 data_length);
			public __get_data get_data;
		};

		[CRepr]
		public struct IDiscordActivityEvents {
			public function void __on_activity_join(void* event_data, char8* secret);
			public __on_activity_join on_activity_join;
			public function void __on_activity_spectate(void* event_data, char8* secret);
			public __on_activity_spectate on_activity_spectate;
			public function void __on_activity_join_request(void* event_data, DiscordUser* user);
			public __on_activity_join_request on_activity_join_request;
			public function void __on_activity_invite(void* event_data, EDiscordActivityActionType type, DiscordUser* user, DiscordActivity* activity);
			public __on_activity_invite on_activity_invite;
		};

		[CRepr]
		public struct IDiscordActivityManager {
			public function EDiscordResult __register_command(IDiscordActivityManager* manager, char8* command);
			public __register_command register_command;
			public function EDiscordResult __register_steam(IDiscordActivityManager* manager, uint32 steam_id);
			public __register_steam register_steam;
			public function void __update_activity(IDiscordActivityManager* manager, DiscordActivity* activity, void* callback_data, Callback callback);
			public __update_activity update_activity;
			public function void __clear_activity(IDiscordActivityManager* manager, void* callback_data, Callback callback);
			public __clear_activity clear_activity;
			public function void __send_request_reply(IDiscordActivityManager* manager, DiscordUserId user_id, EDiscordActivityJoinRequestReply reply, void* callback_data, Callback callback);
			public __send_request_reply send_request_reply;
			public function void __send_invite(IDiscordActivityManager* manager, DiscordUserId user_id, EDiscordActivityActionType type, char8* content, void* callback_data, Callback callback);
			public __send_invite send_invite;
			public function void __accept_invite(IDiscordActivityManager* manager, DiscordUserId user_id, void* callback_data, Callback callback);
			public __accept_invite accept_invite;
		};

		[CRepr]
		public struct IDiscordRelationshipEvents {
			public function void __on_refresh(void* event_data);
			public __on_refresh on_refresh;
			public function void __on_relationship_update(void* event_data, DiscordRelationship* relationship);
			public __on_relationship_update on_relationship_update;
		};

		[CRepr]
		public struct IDiscordRelationshipManager {
			public function void __filter(IDiscordRelationshipManager* manager, void* filter_data, RelationshipFilter filter);
			public __filter filter;
			public function EDiscordResult __count(IDiscordRelationshipManager* manager, int32* count);
			public __count count;
			public function EDiscordResult __get(IDiscordRelationshipManager* manager, DiscordUserId user_id, DiscordRelationship* relationship);
			public __get get;
			public function EDiscordResult __get_at(IDiscordRelationshipManager* manager, uint32 index, DiscordRelationship* relationship);
			public __get_at get_at;
		};

		[CRepr]
		public struct IDiscordLobbyEvents {
			public function void __on_lobby_update(void* event_data, int64 lobby_id);
			public __on_lobby_update on_lobby_update;
			public function void __on_lobby_delete(void* event_data, int64 lobby_id, uint32 reason);
			public __on_lobby_delete on_lobby_delete;
			public function void __on_member_connect(void* event_data, int64 lobby_id, int64 user_id);
			public __on_member_connect on_member_connect;
			public function void __on_member_update(void* event_data, int64 lobby_id, int64 user_id);
			public __on_member_update on_member_update;
			public function void __on_member_disconnect(void* event_data, int64 lobby_id, int64 user_id);
			public __on_member_disconnect on_member_disconnect;
			public function void __on_lobby_message(void* event_data, int64 lobby_id, int64 user_id, uint8* data, uint32 data_length);
			public __on_lobby_message on_lobby_message;
			public function void __on_speaking(void* event_data, int64 lobby_id, int64 user_id, bool speaking);
			public __on_speaking on_speaking;
			public function void __on_network_message(void* event_data, int64 lobby_id, int64 user_id, uint8 channel_id, uint8* data, uint32 data_length);
			public __on_network_message on_network_message;
		};

		[CRepr]
		public struct IDiscordLobbyManager {
			public function EDiscordResult __get_lobby_create_transaction(IDiscordLobbyManager* manager, IDiscordLobbyTransaction** transaction);
			public __get_lobby_create_transaction get_lobby_create_transaction;
			public function EDiscordResult __get_lobby_update_transaction(IDiscordLobbyManager* manager, DiscordLobbyId lobby_id, IDiscordLobbyTransaction** transaction);
			public __get_lobby_update_transaction get_lobby_update_transaction;
			public function EDiscordResult __get_member_update_transaction(IDiscordLobbyManager* manager, DiscordLobbyId lobby_id, DiscordUserId user_id, IDiscordLobbyMemberTransaction** transaction);
			public __get_member_update_transaction get_member_update_transaction;
			public function void __create_lobby(IDiscordLobbyManager* manager, IDiscordLobbyTransaction* transaction, void* callback_data, LobbyCallback callback);
			public __create_lobby create_lobby;
			public function void __update_lobby(IDiscordLobbyManager* manager, DiscordLobbyId lobby_id, IDiscordLobbyTransaction* transaction, void* callback_data, Callback callback);
			public __update_lobby update_lobby;
			public function void __delete_lobby(IDiscordLobbyManager* manager, DiscordLobbyId lobby_id, void* callback_data, Callback callback);
			public __delete_lobby delete_lobby;
			public function void __connect_lobby(IDiscordLobbyManager* manager, DiscordLobbyId lobby_id, DiscordLobbySecret secret, void* callback_data, LobbyCallback callback);
			public __connect_lobby connect_lobby;
			public function void __connect_lobby_with_activity_secret(IDiscordLobbyManager* manager, DiscordLobbySecret activity_secret, void* callback_data, LobbyCallback callback);
			public __connect_lobby_with_activity_secret connect_lobby_with_activity_secret;
			public function void __disconnect_lobby(IDiscordLobbyManager* manager, DiscordLobbyId lobby_id, void* callback_data, Callback callback);
			public __disconnect_lobby disconnect_lobby;
			public function EDiscordResult __get_lobby(IDiscordLobbyManager* manager, DiscordLobbyId lobby_id, DiscordLobby* lobby);
			public __get_lobby get_lobby;
			public function EDiscordResult __get_lobby_activity_secret(IDiscordLobbyManager* manager, DiscordLobbyId lobby_id, DiscordLobbySecret* secret);
			public __get_lobby_activity_secret get_lobby_activity_secret;
			public function EDiscordResult __get_lobby_metadata_value(IDiscordLobbyManager* manager, DiscordLobbyId lobby_id, DiscordMetadataKey key, DiscordMetadataValue* value);
			public __get_lobby_metadata_value get_lobby_metadata_value;
			public function EDiscordResult __get_lobby_metadata_key(IDiscordLobbyManager* manager, DiscordLobbyId lobby_id, int32 index, DiscordMetadataKey* key);
			public __get_lobby_metadata_key get_lobby_metadata_key;
			public function EDiscordResult __lobby_metadata_count(IDiscordLobbyManager* manager, DiscordLobbyId lobby_id, int32* count);
			public __lobby_metadata_count lobby_metadata_count;
			public function EDiscordResult __member_count(IDiscordLobbyManager* manager, DiscordLobbyId lobby_id, int32* count);
			public __member_count member_count;
			public function EDiscordResult __get_member_user_id(IDiscordLobbyManager* manager, DiscordLobbyId lobby_id, int32 index, DiscordUserId* user_id);
			public __get_member_user_id get_member_user_id;
			public function EDiscordResult __get_member_user(IDiscordLobbyManager* manager, DiscordLobbyId lobby_id, DiscordUserId user_id, DiscordUser* user);
			public __get_member_user get_member_user;
			public function EDiscordResult __get_member_metadata_value(IDiscordLobbyManager* manager, DiscordLobbyId lobby_id, DiscordUserId user_id, DiscordMetadataKey key, DiscordMetadataValue* value);
			public __get_member_metadata_value get_member_metadata_value;
			public function EDiscordResult __get_member_metadata_key(IDiscordLobbyManager* manager, DiscordLobbyId lobby_id, DiscordUserId user_id, int32 index, DiscordMetadataKey* key);
			public __get_member_metadata_key get_member_metadata_key;
			public function EDiscordResult __member_metadata_count(IDiscordLobbyManager* manager, DiscordLobbyId lobby_id, DiscordUserId user_id, int32* count);
			public __member_metadata_count member_metadata_count;
			public function void __update_member(IDiscordLobbyManager* manager, DiscordLobbyId lobby_id, DiscordUserId user_id, IDiscordLobbyMemberTransaction* transaction, void* callback_data, Callback callback);
			public __update_member update_member;
			public function void __send_lobby_message(IDiscordLobbyManager* manager, DiscordLobbyId lobby_id, uint8* data, uint32 data_length, void* callback_data, Callback callback);
			public __send_lobby_message send_lobby_message;
			public function EDiscordResult __get_search_query(IDiscordLobbyManager* manager, IDiscordLobbySearchQuery** query);
			public __get_search_query get_search_query;
			public function void __search(IDiscordLobbyManager* manager, IDiscordLobbySearchQuery* query, void* callback_data, Callback callback);
			public __search search;
			public function void __lobby_count(IDiscordLobbyManager* manager, int32* count);
			public __lobby_count lobby_count;
			public function EDiscordResult __get_lobby_id(IDiscordLobbyManager* manager, int32 index, DiscordLobbyId* lobby_id);
			public __get_lobby_id get_lobby_id;
			public function void __connect_voice(IDiscordLobbyManager* manager, DiscordLobbyId lobby_id, void* callback_data, Callback callback);
			public __connect_voice connect_voice;
			public function void __disconnect_voice(IDiscordLobbyManager* manager, DiscordLobbyId lobby_id, void* callback_data, Callback callback);
			public __disconnect_voice disconnect_voice;
			public function EDiscordResult __connect_network(IDiscordLobbyManager* manager, DiscordLobbyId lobby_id);
			public __connect_network connect_network;
			public function EDiscordResult __disconnect_network(IDiscordLobbyManager* manager, DiscordLobbyId lobby_id);
			public __disconnect_network disconnect_network;
			public function EDiscordResult __flush_network(IDiscordLobbyManager* manager);
			public __flush_network flush_network;
			public function EDiscordResult __open_network_channel(IDiscordLobbyManager* manager, DiscordLobbyId lobby_id, uint8 channel_id, bool reliable);
			public __open_network_channel open_network_channel;
			public function EDiscordResult __send_network_message(IDiscordLobbyManager* manager, DiscordLobbyId lobby_id, DiscordUserId user_id, uint8 channel_id, uint8* data, uint32 data_length);
			public __send_network_message send_network_message;
		};

		[CRepr]
		public struct IDiscordNetworkEvents {
			public function void __on_message(void* event_data, DiscordNetworkPeerId peer_id, DiscordNetworkChannelId channel_id, uint8* data, uint32 data_length);
			public __on_message on_message;
			public function void __on_route_update(void* event_data, char8* route_data);
			public __on_route_update on_route_update;
		};

		[CRepr]
		public struct IDiscordNetworkManager {
			/**
			 * Get the local peer ID for this process.
			 */
			public function void __get_peer_id(IDiscordNetworkManager* manager, DiscordNetworkPeerId* peer_id);
			public __get_peer_id get_peer_id;
			/**
			 * Send pending network messages.
			 */
			public function EDiscordResult __flush(IDiscordNetworkManager* manager);
			public __flush flush;
			/**
			 * Open a connection to a remote peer.
			 */
			public function EDiscordResult __open_peer(IDiscordNetworkManager* manager, DiscordNetworkPeerId peer_id, char8* route_data);
			public __open_peer open_peer;
			/**
			 * Update the route data for a connected peer.
			 */
			public function EDiscordResult __update_peer(IDiscordNetworkManager* manager, DiscordNetworkPeerId peer_id, char8* route_data);
			public __update_peer update_peer;
			/**
			 * Close the connection to a remote peer.
			 */
			public function EDiscordResult __close_peer(IDiscordNetworkManager* manager, DiscordNetworkPeerId peer_id);
			public __close_peer close_peer;
			/**
			 * Open a message channel to a connected peer.
			 */
			public function EDiscordResult __open_channel(IDiscordNetworkManager* manager, DiscordNetworkPeerId peer_id, DiscordNetworkChannelId channel_id, bool reliable);
			public __open_channel open_channel;
			/**
			 * Close a message channel to a connected peer.
			 */
			public function EDiscordResult __close_channel(IDiscordNetworkManager* manager, DiscordNetworkPeerId peer_id, DiscordNetworkChannelId channel_id);
			public __close_channel close_channel;
			/**
			 * Send a message to a connected peer over an opened message channel.
			 */
			public function EDiscordResult __send_message(IDiscordNetworkManager* manager, DiscordNetworkPeerId peer_id, DiscordNetworkChannelId channel_id, uint8* data, uint32 data_length);
			public __send_message send_message;
		};

		[CRepr]
		public struct IDiscordOverlayEvents {
			public function void __on_toggle(void* event_data, bool locked);
			public __on_toggle on_toggle;
		};

		[CRepr]
		public struct IDiscordOverlayManager {
			public function void __is_enabled(IDiscordOverlayManager* manager, bool* enabled);
			public __is_enabled is_enabled;
			public function void __is_locked(IDiscordOverlayManager* manager, bool* locked);
			public __is_locked is_locked;
			public function void __set_locked(IDiscordOverlayManager* manager, bool locked, void* callback_data, Callback callback);
			public __set_locked set_locked;
			public function void __open_activity_invite(IDiscordOverlayManager* manager, EDiscordActivityActionType type, void* callback_data, Callback callback);
			public __open_activity_invite open_activity_invite;
			public function void __open_guild_invite(IDiscordOverlayManager* manager, char8* code, void* callback_data, Callback callback);
			public __open_guild_invite open_guild_invite;
			public function void __open_voice_settings(IDiscordOverlayManager* manager, void* callback_data, Callback callback);
			public __open_voice_settings open_voice_settings;
		};

		public typealias IDiscordStorageEvents = void*;

		[CRepr]
		public struct IDiscordStorageManager {
			public function EDiscordResult __read(IDiscordStorageManager* manager, char8* name, uint8* data, uint32 data_length, uint32* read);
			public __read read;
			public function void __read_async(IDiscordStorageManager* manager, char8* name, void* callback_data, ByteCallback callback);
			public __read_async read_async;
			public function void __read_async_partial(IDiscordStorageManager* manager, char8* name, uint64 offset, uint64 length, void* callback_data, ByteCallback callback);
			public __read_async_partial read_async_partial;
			public function EDiscordResult __write(IDiscordStorageManager* manager, char8* name, uint8* data, uint32 data_length);
			public __write write;
			public function void __write_async(IDiscordStorageManager* manager, char8* name, uint8* data, uint32 data_length, void* callback_data, Callback callback);
			public __write_async write_async;
			public function EDiscordResult __delete_(IDiscordStorageManager* manager, char8* name);
			public __delete_ delete_;
			public function EDiscordResult __exists(IDiscordStorageManager* manager, char8* name, bool* exists);
			public __exists exists;
			public function void __count(IDiscordStorageManager* manager, int32* count);
			public __count count;
			public function EDiscordResult __stat(IDiscordStorageManager* manager, char8* name, DiscordFileStat* stat);
			public __stat stat;
			public function EDiscordResult __stat_at(IDiscordStorageManager* manager, int32 index, DiscordFileStat* stat);
			public __stat_at stat_at;
			public function EDiscordResult __get_path(IDiscordStorageManager* manager, DiscordPath* path);
			public __get_path get_path;
		};

		[CRepr]
		public struct IDiscordStoreEvents {
			public function void __on_entitlement_create(void* event_data, DiscordEntitlement* entitlement);
			public __on_entitlement_create on_entitlement_create;
			public function void __on_entitlement_delete(void* event_data, DiscordEntitlement* entitlement);
			public __on_entitlement_delete on_entitlement_delete;
		};

		[CRepr]
		public struct IDiscordStoreManager {
			public function void __fetch_skus(IDiscordStoreManager* manager, void* callback_data, Callback callback);
			public __fetch_skus fetch_skus;
			public function void __count_skus(IDiscordStoreManager* manager, int32* count);
			public __count_skus count_skus;
			public function EDiscordResult __get_sku(IDiscordStoreManager* manager, DiscordSnowflake sku_id, DiscordSku* sku);
			public __get_sku get_sku;
			public function EDiscordResult __get_sku_at(IDiscordStoreManager* manager, int32 index, DiscordSku* sku);
			public __get_sku_at get_sku_at;
			public function void __fetch_entitlements(IDiscordStoreManager* manager, void* callback_data, Callback callback);
			public __fetch_entitlements fetch_entitlements;
			public function void __count_entitlements(IDiscordStoreManager* manager, int32* count);
			public __count_entitlements count_entitlements;
			public function EDiscordResult __get_entitlement(IDiscordStoreManager* manager, DiscordSnowflake entitlement_id, DiscordEntitlement* entitlement);
			public __get_entitlement get_entitlement;
			public function EDiscordResult __get_entitlement_at(IDiscordStoreManager* manager, int32 index, DiscordEntitlement* entitlement);
			public __get_entitlement_at get_entitlement_at;
			public function EDiscordResult __has_sku_entitlement(IDiscordStoreManager* manager, DiscordSnowflake sku_id, bool* has_entitlement);
			public __has_sku_entitlement has_sku_entitlement;
			public function void __start_purchase(IDiscordStoreManager* manager, DiscordSnowflake sku_id, void* callback_data, Callback callback);
			public __start_purchase start_purchase;
		};

		[CRepr]
		public struct IDiscordVoiceEvents {
			public function void __on_settings_update(void* event_data);
			public __on_settings_update on_settings_update;
		};

		[CRepr]
		public struct IDiscordVoiceManager {
			public function EDiscordResult __get_input_mode(IDiscordVoiceManager* manager, DiscordInputMode* input_mode);
			public __get_input_mode get_input_mode;
			public function void __set_input_mode(IDiscordVoiceManager* manager, DiscordInputMode input_mode, void* callback_data, Callback callback);
			public __set_input_mode set_input_mode;
			public function EDiscordResult __is_self_mute(IDiscordVoiceManager* manager, bool* mute);
			public __is_self_mute is_self_mute;
			public function EDiscordResult __set_self_mute(IDiscordVoiceManager* manager, bool mute);
			public __set_self_mute set_self_mute;
			public function EDiscordResult __is_self_deaf(IDiscordVoiceManager* manager, bool* deaf);
			public __is_self_deaf is_self_deaf;
			public function EDiscordResult __set_self_deaf(IDiscordVoiceManager* manager, bool deaf);
			public __set_self_deaf set_self_deaf;
			public function EDiscordResult __is_local_mute(IDiscordVoiceManager* manager, DiscordSnowflake user_id, bool* mute);
			public __is_local_mute is_local_mute;
			public function EDiscordResult __set_local_mute(IDiscordVoiceManager* manager, DiscordSnowflake user_id, bool mute);
			public __set_local_mute set_local_mute;
			public function EDiscordResult __get_local_volume(IDiscordVoiceManager* manager, DiscordSnowflake user_id, uint8* volume);
			public __get_local_volume get_local_volume;
			public function EDiscordResult __set_local_volume(IDiscordVoiceManager* manager, DiscordSnowflake user_id, uint8 volume);
			public __set_local_volume set_local_volume;
		};

		[CRepr]
		public struct IDiscordAchievementEvents {
			public function void __on_user_achievement_update(void* event_data, DiscordUserAchievement* user_achievement);
			public __on_user_achievement_update on_user_achievement_update;
		};

		[CRepr]
		public struct IDiscordAchievementManager {
			public function void __set_user_achievement(IDiscordAchievementManager* manager, DiscordSnowflake achievement_id, uint8 percent_complete, void* callback_data, Callback callback);
			public __set_user_achievement set_user_achievement;
			public function void __fetch_user_achievements(IDiscordAchievementManager* manager, void* callback_data, Callback callback);
			public __fetch_user_achievements fetch_user_achievements;
			public function void __count_user_achievements(IDiscordAchievementManager* manager, int32* count);
			public __count_user_achievements count_user_achievements;
			public function EDiscordResult __get_user_achievement(IDiscordAchievementManager* manager, DiscordSnowflake user_achievement_id, DiscordUserAchievement* user_achievement);
			public __get_user_achievement get_user_achievement;
			public function EDiscordResult __get_user_achievement_at(IDiscordAchievementManager* manager, int32 index, DiscordUserAchievement* user_achievement);
			public __get_user_achievement_at get_user_achievement_at;
		};

		public typealias IDiscordCoreEvents = void*;

		[CRepr]
		public struct IDiscordCore {
			public function void __destroy(IDiscordCore* core);
			public __destroy destroy;
			public function EDiscordResult __run_callbacks(IDiscordCore* core);
			public __run_callbacks run_callbacks;
			public function void __set_log_hook(IDiscordCore* core, EDiscordLogLevel min_level, void* hook_data, LogHook hook);
			public __set_log_hook set_log_hook;
			public function IDiscordApplicationManager* __get_application_manager(IDiscordCore* core);
			public __get_application_manager get_application_manager;
			public function IDiscordUserManager* __get_user_manager(IDiscordCore* core);
			public __get_user_manager get_user_manager;
			public function IDiscordImageManager* __get_image_manager(IDiscordCore* core);
			public __get_image_manager get_image_manager;
			public function IDiscordActivityManager* __get_activity_manager(IDiscordCore* core);
			public __get_activity_manager get_activity_manager;
			public function IDiscordRelationshipManager* __get_relationship_manager(IDiscordCore* core);
			public __get_relationship_manager get_relationship_manager;
			public function IDiscordLobbyManager* __get_lobby_manager(IDiscordCore* core);
			public __get_lobby_manager get_lobby_manager;
			public function IDiscordNetworkManager* __get_network_manager(IDiscordCore* core);
			public __get_network_manager get_network_manager;
			public function IDiscordOverlayManager* __get_overlay_manager(IDiscordCore* core);
			public __get_overlay_manager get_overlay_manager;
			public function IDiscordStorageManager* __get_storage_manager(IDiscordCore* core);
			public __get_storage_manager get_storage_manager;
			public function IDiscordStoreManager* __get_store_manager(IDiscordCore* core);
			public __get_store_manager get_store_manager;
			public function IDiscordVoiceManager* __get_voice_manager(IDiscordCore* core);
			public __get_voice_manager get_voice_manager;
			public function IDiscordAchievementManager* __get_achievement_manager(IDiscordCore* core);
			public __get_achievement_manager get_achievement_manager;
		};

		[CRepr]
		public struct DiscordCreateParams {
			public DiscordClientId client_id;
			public uint64 flags;
			public IDiscordCoreEvents* events;
			public void* event_data;
			public IDiscordApplicationEvents* application_events;
			public DiscordVersion application_version;
			public IDiscordUserEvents* user_events;
			public DiscordVersion user_version;
			public IDiscordImageEvents* image_events;
			public DiscordVersion image_version;
			public IDiscordActivityEvents* activity_events;
			public DiscordVersion activity_version;
			public IDiscordRelationshipEvents* relationship_events;
			public DiscordVersion relationship_version;
			public IDiscordLobbyEvents* lobby_events;
			public DiscordVersion lobby_version;
			public IDiscordNetworkEvents* network_events;
			public DiscordVersion network_version;
			public IDiscordOverlayEvents* overlay_events;
			public DiscordVersion overlay_version;
			public IDiscordStorageEvents* storage_events;
			public DiscordVersion storage_version;
			public IDiscordStoreEvents* store_events;
			public DiscordVersion store_version;
			public IDiscordVoiceEvents* voice_events;
			public DiscordVersion voice_version;
			public IDiscordAchievementEvents* achievement_events;
			public DiscordVersion achievement_version;
		};

		public static void DiscordCreateParamsSetDefault(DiscordCreateParams* param)
		{
			Internal.MemSet(param, 0, sizeof(DiscordCreateParams));
			param.application_version = DISCORD_APPLICATION_MANAGER_VERSION;
			param.user_version = DISCORD_USER_MANAGER_VERSION;
			param.image_version = DISCORD_IMAGE_MANAGER_VERSION;
			param.activity_version = DISCORD_ACTIVITY_MANAGER_VERSION;
			param.relationship_version = DISCORD_RELATIONSHIP_MANAGER_VERSION;
			param.lobby_version = DISCORD_LOBBY_MANAGER_VERSION;
			param.network_version = DISCORD_NETWORK_MANAGER_VERSION;
			param.overlay_version = DISCORD_OVERLAY_MANAGER_VERSION;
			param.storage_version = DISCORD_STORAGE_MANAGER_VERSION;
			param.store_version = DISCORD_STORE_MANAGER_VERSION;
			param.voice_version = DISCORD_VOICE_MANAGER_VERSION;
			param.achievement_version = DISCORD_ACHIEVEMENT_MANAGER_VERSION;
		}

		[CLink]
		public extern static EDiscordResult DiscordCreate(DiscordVersion version, DiscordCreateParams* param, IDiscordCore** result);
	}
}